package acar.user_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Map.Entry;

import acar.database.*;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;
import acar.insur.InsDatabase;
import acar.account.*;
import acar.beans.AttachedFile;
import acar.common.*;
import acar.util.*;
import acar.mng_exp.*;
import java.awt.print.*;


import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import java.io.File;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.TrueFileFilter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class attachFileTableInsert {
	static String url;
	
	public static void main(String[] args) {
		 // ���� ����(name, size) ���� ����Ʈ �� ����
		 List<Map<String, Object>> listMapInsert = new ArrayList<Map<String, Object>>();
		 String name = "";
		 int size = 0;
		 
		// ���ÿ� ����� ���� ���(198���� �ö� ������ ����ٰ� �÷���� ��)
		String isDir = "D:\\test\\02";
      
		// ���� ���丮 
        for (File info : new File(isDir).listFiles()) {
            if (info.isDirectory()) {
            }
            if (info.isFile()) {
            }
        }
        
        // ������ ��� ���� �˻� �� ����Ʈ�� map�� add
        for (File info : FileUtils.listFiles(new File(isDir), TrueFileFilter.INSTANCE, TrueFileFilter.INSTANCE)) {
            System.out.println(info.getName());
            System.out.println(info.length());
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("name", info.getName());
            map.put("size", info.length());
            
            listMapInsert.add(map);
        }
       
        // ��� ����(�ߺ� �˻�� SELECT)
		url = "jdbc:oracle:thin:@211.174.180.103:1521:AMCAR";
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		// ��� ����(INSERT)
		Connection conn2 = null;
		Statement stmt2 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		String col1 = null;
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver"); // JDBC ����̹� �ε�
			conn = DriverManager.getConnection(url, "amazoncar", "jjkamazoncar7$"); // �����ͺ��̽� ����(id/pw)
			if (conn == null) {
				System.out.println("�������");
			} else {
				System.out.println("���Ἲ��");
				
				List<Map<String, Object>> listMapSelect = listMapInsert;
				
				// ����Ʈ�ʿ� ����� ������ ��ŭ �ݺ� ����
				for(int i=0; i<listMapSelect.size(); i++) {					
					HashMap<String, Object> hashmap = new HashMap<String, Object>(listMapSelect.get(i));
					
					name = (String) hashmap.get("name");
					size = Integer.parseInt(String.valueOf(hashmap.get("size")));
					int index = name.indexOf(".");
					String content_seq = name.substring(0,index);
					String save_file = "INSUR_" + name;
					
					// ���� �ߺ� �˻�� SELECT�� ����(�������� ��û��� ȭ�鿡�� ��� �� content_seq ������ ���� �޶� LIKE �˻� �ʿ�)
					String sql = "SELECT count(*) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE = 'INSUR' AND CONTENT_SEQ LIKE '%"+content_seq+"%'"; 
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					// ���
					while (rs.next()) {
						col1 = rs.getString(1);
						
						int col1_int = Integer.parseInt(String.valueOf(rs.getString(1)));
						// �ߺ� �˻� COUNT�� ���� 0�� ��쿡�� �μ�Ʈ ����
						if(col1_int == 0) {
							System.out.println("�μ�Ʈ ���� (�ߺ�X)");
							System.out.println("���ε� ���� �� > " + name);
							
							//���� �� �ּ� ���� *******************************************************
//							String sql2 = "insert into ACAR_ATTACH_FILE ("+ 
//											" CONTENT_CODE, CONTENT_SEQ, FILE_NAME, FILE_SIZE, FILE_TYPE, SAVE_FILE, SAVE_FOLDER, REG_USERSEQ, REG_DATE, ISDELETED  "+
//											" ) values("+
//											" 'INSUR', '"+content_seq+"', '"+name+"', '"+size+"', 'application/pdf', '"+name+"' , '/attach/INSUR/2022/02/', '000350', SYSDATE, 'N' "+
//											" )";
							//���� �� �ּ� ���� *******************************************************
							
							//���� �� �ּ� ó��*******************************************************
							String sql2 = "insert into ACAR_ATTACH_FILE2 ("+ 
											" SEQ, CONTENT_CODE, CONTENT_SEQ, FILE_NAME, FILE_SIZE, FILE_TYPE, SAVE_FILE, SAVE_FOLDER, REG_USERSEQ, REG_DATE, ISDELETED  "+
											" ) values("+
											" ACAR_ATTACH_FILE_SEQ.nextval,'INSUR', '"+content_seq+"', '"+name+"', '"+size+"', 'application/pdf', '"+name+"' , '/attach/INSUR/2022/02/', '000350', SYSDATE, 'N' "+
											" )";
							//���� �� �ּ� ó�� *******************************************************
							
							try 
							{ 
								conn2 = DriverManager.getConnection(url, "amazoncar", "jjkamazoncar7$");
								
								conn2.setAutoCommit(false);
								pstmt2 = conn2.prepareStatement(sql2);
							    pstmt2.executeUpdate();
								pstmt2.close();
								conn2.commit();

						  	} catch (Exception e) {
								System.out.println("[InsDatabase:insertInsChange]"+ e);
								e.printStackTrace();
								conn2.rollback();
							} finally {
								try{	
									conn2.setAutoCommit(true);
									if(pstmt2 != null)	pstmt2.close();
								}catch(Exception ignore){}
								if ( conn2 != null ) 
								{
									if (rs2 != null) {
										rs2.close();
									}
									if (pstmt2 != null) {
										pstmt2.close();
									}
									if (stmt2 != null) {
										stmt2.close();
									}
									if (conn2 != null) {
										conn2.close();
									}
								}	
							}	
						} else {
							System.out.println("�μ�Ʈ �̽���(������ �ߺ�)");
						}
					}
				}
			} 
		} catch (ClassNotFoundException ce) {
			ce.printStackTrace();
		} catch (SQLException se) {
			se.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			try { // ���� ����(������ �����Ƿ�)
				if (rs != null) {
					rs.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
				if (stmt != null) {
					stmt.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException se2) {
				se2.printStackTrace();
			}
		}
	}	

}
