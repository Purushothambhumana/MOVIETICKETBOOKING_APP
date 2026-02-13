package com.bookmyshow.config;

import com.bookmyshow.entity.Role;
import com.bookmyshow.entity.User;
import com.bookmyshow.repository.RoleRepository;
import com.bookmyshow.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Create roles if they don't exist
        Role userRole = null;
        Role adminRole = null;

        if (roleRepository.count() == 0) {
            userRole = new Role();
            userRole.setName(Role.RoleName.ROLE_USER);
            roleRepository.save(userRole);

            adminRole = new Role();
            adminRole.setName(Role.RoleName.ROLE_ADMIN);
            roleRepository.save(adminRole);

            System.out.println("✅ Default roles created: ROLE_USER and ROLE_ADMIN");
        } else {
            System.out.println("✅ Roles already exist in database");
            userRole = roleRepository.findByName(Role.RoleName.ROLE_USER).orElse(null);
            adminRole = roleRepository.findByName(Role.RoleName.ROLE_ADMIN).orElse(null);
        }

        // Create admin user if doesn't exist
        if (!userRepository.existsByUsername("admin")) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@bookmyshow.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setPhone("1234567890");

            Set<Role> roles = new HashSet<>();
            if (userRole != null)
                roles.add(userRole);
            if (adminRole != null)
                roles.add(adminRole);
            admin.setRoles(roles);

            userRepository.save(admin);
            System.out.println("✅ Default admin user created (username: admin, password: admin123)");
        } else {
            System.out.println("✅ Admin user already exists");
        }
    }
}
