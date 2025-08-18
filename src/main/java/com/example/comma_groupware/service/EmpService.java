package com.example.comma_groupware.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.comma_groupware.dto.Employee;
import com.example.comma_groupware.dto.Page;
import com.example.comma_groupware.mapper.EmpMapper;

@Service
public class EmpService {

    @Autowired
    private EmpMapper empMapper;

    // 직원 수 조회
    public int getEmployeeCount(String searchWord) {
        return empMapper.selectEmployeeCount(searchWord);
    }

    // 직원 리스트 조회
    public List<Employee> getEmployeeList(Page page) {
        Map<String, Object> param = new HashMap<>();
        param.put("beginRow", page.getBeginRow());
        param.put("rowPerPage", page.getRowPerPage());
        param.put("searchWord", page.getSearchWord());

        return empMapper.selectEmployeeList(param);
    }
}
