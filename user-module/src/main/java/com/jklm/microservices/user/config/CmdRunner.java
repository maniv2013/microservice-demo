/**
 * Copyright (C) 2021 jklm, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALING
 * IN THE SOFTWARE.
 */

package com.jklm.microservices.user.config;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Can be used for sanity test on startup. Components of the type CommandLineRunner are called right after the
 * application start up. So the method run() is called as soon as the application starts.
 */
@Component
public class CmdRunner implements CommandLineRunner {

  @Autowired private UserRepository userRepository;

  @Override
  public void run(String... strings) throws Exception {  
    UserRepository repo = userRepository.withScope("tenant").withCollection("users");

    User userObj = new User("mani-9791033115","mani","pwd");
    
    repo.save(userObj);

    Optional<User> user = userRepository.findById("mani-9791033115"); // SFO
    if(user.isPresent())
      System.out.println("got SFO: " + user.get().id );
    else 
      System.out.println("no SFO: user"  );
    /*try { 
      List<User> users = repo.findByNameStartsWith("MANI");
      if(!users.isEmpty())  
        System.out.println("users that start with San :" + users);
    } catch (Exception e) {
      e.printStackTrace();
    }*/
  }

}
