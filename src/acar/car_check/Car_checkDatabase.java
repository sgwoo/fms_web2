package acar.car_check;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class Car_checkDatabase
{
	private Connection conn = null;
	public static Car_checkDatabase db;
	
	public static Car_checkDatabase getInstance()
	{
		if(Car_checkDatabase.db == null)
			Car_checkDatabase.db = new Car_checkDatabase();
		return Car_checkDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("acar");				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("acar", conn);
			conn = null;
		}		
	}


	
	 //자동차조회
	
	public Vector getCarSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select \n"+
				"        decode(a.use_yn,'N','해지','Y','대여','','대기') use_st, \n"+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_start_dt, a.rent_end_dt, \n"+
				"        nvl(b.car_no,nvl(g.est_car_no,nvl(g.car_num,g.rpt_no))) car_no, e.car_name, f.car_nm, \n"+
				"        b.car_y_form, b.init_reg_dt, c.firm_nm, c.client_nm, d.colo, \n"+
				"        decode(substr(b.init_reg_dt, 1,6), '','신차','신차아님') as shin_car, \n"+
				"        decode( a.car_gu, '1', '신차','신차아님' ) AS car_gu, \n"+
				"        i.cls_dt, substrb(e.car_b,1,2000) car_b, "+
				"        d.opt, decode(d.hipass_yn,'Y','있음','N','없음','') hipass_yn \n"+
				" from   cont a, car_reg b, car_etc d, client c, car_nm e, car_mng f, car_pur g, sui h, cls_cont i  \n"+
				" where  a.car_mng_id=b.car_mng_id(+) \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				"        and a.client_id=c.client_id \n"+
				"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
				"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        and a.car_mng_id=h.car_mng_id(+)  \n"+	
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.cls_dt is null \n"+
				" ";
	
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and nvl(b.car_no,g.est_car_no)||b.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and replace(upper(nvl(g.rpt_no, ' ')),'-','')  like replace(upper('%"+t_wd+"%'),'-','')";
		else if(s_kd.equals("4"))	query += " and nvl(b.car_num,g.car_num) like '%"+t_wd+"%'";
		else						query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		if(s_kd.equals("1"))		query += "\n order by b.init_reg_dt desc, c.firm_nm, b.car_no, a.rent_dt desc";
		else if(s_kd.equals("2"))	query += "\n order by b.init_reg_dt desc, b.car_no, a.rent_dt desc";
		else						query += "\n order by b.init_reg_dt desc, a.rent_dt desc";


				
//System.out.println("[ClientMngDatabase:getCarSearch]\n"+query);

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ClientMngDatabase:getCarSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getCarSearch]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}



	
	//세차등록.

	public String input_carcheck(Car_checkBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String check_no = "";
		String query =  " insert into CAR_CHECK "+
						" ( check_no, off_id, off_nm, reg_id, reg_dt, car_mng_id, rent_mng_id, rent_l_cd, rent_s_cd, driver_nm, driver_tel, "+

						"  a1,a2,a3,a4,a5,a6, b1,b2,b3,b4,b5,b6, c1,c2,c3,c4,c5,c6, d1,d2,d3,d4,d5,d6, e1,e2,e3,e4,e5,e6, "+
						"  f1,f2,f3,f4,f5,f6, g1,g2,g3,g4,g5,g6, h1,h2,h3,h4,h5,h6, i1,i2,i3,i4,i5,i6, j1,j2,j3,j4,j5,j6, "+

						"  k1,k2,k3,k4,k5,k6, l1,l2,l3,l4,l5,l6, m1,m2,m3,m4,m5,m6, n1,n2,n3,n4,n5,n6, aa1,aa2,aa3,aa4,aa5,aa6, "+

						"  ab1,ab2,ab3,ab4,ab5,ab6, ac1,ac2,ac3,ac4,ac5,ac6, ad1,ad2,ad3,ad4,ad5,ad6, ae1,ae2,ae3,ae4,ae5,ae6, "+ 
						"  af1,af2,af3,af4,af5,af6, ag1,ag2,ag3,ag4,ag5,ag6, ah1,ah2,ah3,ah4,ah5,ah6, ai1,ai2,ai3,ai4,ai5,ai6, "+
						"  aj1,aj2,aj3,aj4,aj5,aj6, ak1,ak2,ak3,ak4,ak5,ak6, al1,al2,al3,al4,al5,al6, am1,am2,am3,am4,am5,am6, "+
						"  an1,an2,an3,an4,an5,an6, ao1,ao2,ao3,ao4,ao5,ao6, ap1,ap2,ap3,ap4,ap5,ap6, aq1,aq2,aq3,aq4,aq5,aq6, "+
						"  ar1,ar2,ar3,ar4,ar5,ar6, as1,as2,as3,as4,as5,as6, at1,at2,at3,at4,at5,at6, au1,au2,au3,au4,au5,au6, "+
						"  av1,av2,av3,av4,av5,av6, aw1,aw2,aw3,aw4,aw5,aw6, ax1,ax2,ax3,ax4,ax5,ax6, ay1,ay2,ay3,ay4,ay5,ay6 "+
						"  ,dist, rm_st, rm_cont, firm_nm, mng_id, mng_check, mng_check_dt, mng_id2) values "+
						" ( ?, ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, "+

						"   ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, "+
						"   ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, "+

						"   ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, "+ 

						"	?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, "+
						"	?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, "+
						"	?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, "+
						"	?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, "+
						"	?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, "+
						"	?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,? "+
						"	, replace(?,',',''), ?, ?, ?, ?, ?, replace(?,'-',''), ?)";

		String qry_id = " select '점검'||to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(check_no,11,4))+1), '0000')), '0001') check_no"+
						" from CAR_CHECK "+
						" where substr(check_no,3,8)=to_char(sysdate,'YYYYMMDD')";

//System.out.println("[Car_checkDatabase:input_carcheck]"+qry_id);

		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				check_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[Car_checkDatabase:input_carcheck]"+e);
				System.out.println("[Car_checkDatabase:input_carcheck]"+query);
	            conn.rollback();
				e.printStackTrace();	
				flag = false;
	        }catch(SQLException _ignored){}
		}finally{
			try{
                if(rs != null )		rs.close();
	            if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
		}

		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			if(bean.getCheck_no().equals("")){
				pstmt2.setString(1,  check_no		      );
			}else{
				pstmt2.setString(1,  bean.getCheck_no	());
				check_no = bean.getCheck_no();
			}
			pstmt2.setString(2,  bean.getOff_id			());
			pstmt2.setString(3,  bean.getOff_nm			());
			pstmt2.setString(4,	 bean.getReg_id			());
//			pstmt2.setString(5,  bean.getReg_dt			());
			pstmt2.setString(5,  bean.getCar_mng_id		());
			pstmt2.setString(6,  bean.getRent_mng_id	());
			pstmt2.setString(7,  bean.getRent_l_cd		());
			pstmt2.setString(8,  bean.getRent_s_cd		());
			pstmt2.setString(9, bean.getDriver_nm		());
			pstmt2.setString(10, bean.getDriver_tel		());

			pstmt2.setString(11, bean.getA1			());
			pstmt2.setString(12, bean.getA2			());
			pstmt2.setString(13, bean.getA3			());
			pstmt2.setString(14, bean.getA4			());
			pstmt2.setString(15, bean.getA5			());
			pstmt2.setString(16, bean.getA6			());

			pstmt2.setString(17, bean.getB1			());
			pstmt2.setString(18, bean.getB2			());
			pstmt2.setString(19, bean.getB3			());
			pstmt2.setString(20, bean.getB4			());
			pstmt2.setString(21, bean.getB5			());
			pstmt2.setString(22, bean.getB6			());

			pstmt2.setString(23, bean.getC1			());
			pstmt2.setString(24, bean.getC2			());
			pstmt2.setString(25, bean.getC3			());
			pstmt2.setString(26, bean.getC4			());
			pstmt2.setString(27, bean.getC5			());
			pstmt2.setString(28, bean.getC6			());

			pstmt2.setString(29, bean.getD1			());
			pstmt2.setString(30, bean.getD2			());
			pstmt2.setString(31, bean.getD3			());
			pstmt2.setString(32, bean.getD4			());
			pstmt2.setString(33, bean.getD5			());
			pstmt2.setString(34, bean.getD6			());

			pstmt2.setString(35, bean.getE1			());
			pstmt2.setString(36, bean.getE2			());
			pstmt2.setString(37, bean.getE3			());
			pstmt2.setString(38, bean.getE4			());
			pstmt2.setString(39, bean.getE5			());
			pstmt2.setString(40, bean.getE6			());

			pstmt2.setString(41, bean.getF1			());
			pstmt2.setString(42, bean.getF2			());
			pstmt2.setString(43, bean.getF3			());
			pstmt2.setString(44, bean.getF4			());
			pstmt2.setString(45, bean.getF5			());
			pstmt2.setString(46, bean.getF6			());

			pstmt2.setString(47, bean.getG1			());
			pstmt2.setString(48, bean.getG2			());
			pstmt2.setString(49, bean.getG3			());
			pstmt2.setString(50, bean.getG4			());
			pstmt2.setString(51, bean.getG5			());
			pstmt2.setString(52, bean.getG6			());

			pstmt2.setString(53, bean.getH1			());
			pstmt2.setString(54, bean.getH2			());
			pstmt2.setString(55, bean.getH3			());
			pstmt2.setString(56, bean.getH4			());
			pstmt2.setString(57, bean.getH5			());
			pstmt2.setString(58, bean.getH6			());

			pstmt2.setString(59, bean.getI1			());
			pstmt2.setString(60, bean.getI2			());
			pstmt2.setString(61, bean.getI3			());
			pstmt2.setString(62, bean.getI4			());
			pstmt2.setString(63, bean.getI5			());
			pstmt2.setString(64, bean.getI6			());

			pstmt2.setString(65, bean.getJ1			());
			pstmt2.setString(66, bean.getJ2			());
			pstmt2.setString(67, bean.getJ3			());
			pstmt2.setString(68, bean.getJ4			());
			pstmt2.setString(69, bean.getJ5			());
			pstmt2.setString(70, bean.getJ6			());

			pstmt2.setString(71, bean.getK1			());
			pstmt2.setString(72, bean.getK2			());
			pstmt2.setString(73, bean.getK3			());
			pstmt2.setString(74, bean.getK4			());
			pstmt2.setString(75, bean.getK5			());
			pstmt2.setString(76, bean.getK6			());

			pstmt2.setString(77, bean.getL1			());
			pstmt2.setString(78, bean.getL2			());
			pstmt2.setString(79, bean.getL3			());
			pstmt2.setString(80, bean.getL4			());
			pstmt2.setString(81, bean.getL5			());
			pstmt2.setString(82, bean.getL6			());

			pstmt2.setString(83, bean.getM1			());
			pstmt2.setString(84, bean.getM2			());
			pstmt2.setString(85, bean.getM3			());
			pstmt2.setString(86, bean.getM4			());
			pstmt2.setString(87, bean.getM5			());
			pstmt2.setString(88, bean.getM6			());

			pstmt2.setString(89, bean.getN1			());
			pstmt2.setString(90, bean.getN2			());
			pstmt2.setString(91, bean.getN3			());
			pstmt2.setString(92, bean.getN4			());
			pstmt2.setString(93, bean.getN5			());
			pstmt2.setString(94, bean.getN6			());

			pstmt2.setString(95, bean.getAa1			());
			pstmt2.setString(96, bean.getAa2			());
			pstmt2.setString(97, bean.getAa3			());
			pstmt2.setString(98, bean.getAa4			());
			pstmt2.setString(99, bean.getAa5			());
			pstmt2.setString(100, bean.getAa6			());

			pstmt2.setString(101, bean.getAb1			());
			pstmt2.setString(102, bean.getAb2			());
			pstmt2.setString(103, bean.getAb3			());
			pstmt2.setString(104, bean.getAb4			());
			pstmt2.setString(105, bean.getAb5			());
			pstmt2.setString(106, bean.getAb6			());
			
			pstmt2.setString(107, bean.getAc1			());
			pstmt2.setString(108, bean.getAc2			());
			pstmt2.setString(109, bean.getAc3			());
			pstmt2.setString(110, bean.getAc4			());
			pstmt2.setString(111, bean.getAc5			());
			pstmt2.setString(112, bean.getAc6			());
			
			pstmt2.setString(113, bean.getAd1			());
			pstmt2.setString(114, bean.getAd2			());
			pstmt2.setString(115, bean.getAd3			());
			pstmt2.setString(116, bean.getAd4			());
			pstmt2.setString(117, bean.getAd5			());
			pstmt2.setString(118, bean.getAd6			());
			
			pstmt2.setString(119, bean.getAe1			());
			pstmt2.setString(120, bean.getAe2			());
			pstmt2.setString(121, bean.getAe3			());
			pstmt2.setString(122, bean.getAe4			());
			pstmt2.setString(123, bean.getAe5			());
			pstmt2.setString(124, bean.getAe6			());
			
			pstmt2.setString(125, bean.getAf1			());
			pstmt2.setString(126, bean.getAf2			());
			pstmt2.setString(127, bean.getAf3			());
			pstmt2.setString(128, bean.getAf4			());
			pstmt2.setString(129, bean.getAf5			());
			pstmt2.setString(130, bean.getAf6			());
			
			pstmt2.setString(131, bean.getAg1			());
			pstmt2.setString(132, bean.getAg2			());
			pstmt2.setString(133, bean.getAg3			());
			pstmt2.setString(134, bean.getAg4			());
			pstmt2.setString(135, bean.getAg5			());
			pstmt2.setString(136, bean.getAg6			());

			pstmt2.setString(137, bean.getAh1			());
			pstmt2.setString(138, bean.getAh2			());
			pstmt2.setString(139, bean.getAh3			());
			pstmt2.setString(140, bean.getAh4			());
			pstmt2.setString(141, bean.getAh5			());
			pstmt2.setString(142, bean.getAh6			());
			
			pstmt2.setString(143, bean.getAi1			());
			pstmt2.setString(144, bean.getAi2			());
			pstmt2.setString(145, bean.getAi3			());
			pstmt2.setString(146, bean.getAi4			());
			pstmt2.setString(147, bean.getAi5			());
			pstmt2.setString(148, bean.getAi6			());
			
			pstmt2.setString(149, bean.getAj1			());
			pstmt2.setString(150, bean.getAj2			());
			pstmt2.setString(151, bean.getAj3			());
			pstmt2.setString(152, bean.getAj4			());
			pstmt2.setString(153, bean.getAj5			());
			pstmt2.setString(154, bean.getAj6			());
			
			pstmt2.setString(155, bean.getAk1			());
			pstmt2.setString(156, bean.getAk2			());
			pstmt2.setString(157, bean.getAk3			());
			pstmt2.setString(158, bean.getAk4			());
			pstmt2.setString(159, bean.getAk5			());
			pstmt2.setString(160, bean.getAk6			());
			
			pstmt2.setString(161, bean.getAl1			());
			pstmt2.setString(162, bean.getAl2			());
			pstmt2.setString(163, bean.getAl3			());
			pstmt2.setString(164, bean.getAl4			());
			pstmt2.setString(165, bean.getAl5			());
			pstmt2.setString(166, bean.getAl6			());
			
			pstmt2.setString(167, bean.getAm1			());
			pstmt2.setString(168, bean.getAm2			());
			pstmt2.setString(169, bean.getAm3			());
			pstmt2.setString(170, bean.getAm4			());
			pstmt2.setString(171, bean.getAm5			());
			pstmt2.setString(172, bean.getAm6			());
			
			pstmt2.setString(173, bean.getAn1			());
			pstmt2.setString(174, bean.getAn2			());
			pstmt2.setString(175, bean.getAn3			());
			pstmt2.setString(176, bean.getAn4			());
			pstmt2.setString(177, bean.getAn5			());
			pstmt2.setString(178, bean.getAn6			());
			
			pstmt2.setString(179, bean.getAo1			());
			pstmt2.setString(180, bean.getAo2			());
			pstmt2.setString(181, bean.getAo3			());
			pstmt2.setString(182, bean.getAo4			());
			pstmt2.setString(183, bean.getAo5			());
			pstmt2.setString(184, bean.getAo6			());
			
			pstmt2.setString(185, bean.getAp1			());
			pstmt2.setString(186, bean.getAp2			());
			pstmt2.setString(187, bean.getAp3			());
			pstmt2.setString(188, bean.getAp4			());
			pstmt2.setString(189, bean.getAp5			());
			pstmt2.setString(190, bean.getAp6			());
			
			pstmt2.setString(191, bean.getAq1			());
			pstmt2.setString(192, bean.getAq2			());
			pstmt2.setString(193, bean.getAq3			());
			pstmt2.setString(194, bean.getAq4			());
			pstmt2.setString(195, bean.getAq5			());
			pstmt2.setString(196, bean.getAq6			());
			
			pstmt2.setString(197, bean.getAr1			());
			pstmt2.setString(198, bean.getAr2			());
			pstmt2.setString(199, bean.getAr3			());
			pstmt2.setString(200, bean.getAr4			());
			pstmt2.setString(201, bean.getAr5			());
			pstmt2.setString(202, bean.getAr6			());
			
			pstmt2.setString(203, bean.getAs1			());
			pstmt2.setString(204, bean.getAs2			());
			pstmt2.setString(205, bean.getAs3			());
			pstmt2.setString(206, bean.getAs4			());
			pstmt2.setString(207, bean.getAs5			());
			pstmt2.setString(208, bean.getAs6			());
			
			pstmt2.setString(209, bean.getAt1			());
			pstmt2.setString(210, bean.getAt2			());
			pstmt2.setString(211, bean.getAt3			());
			pstmt2.setString(212, bean.getAt4			());
			pstmt2.setString(213, bean.getAt5			());
			pstmt2.setString(214, bean.getAt6			());
			
			pstmt2.setString(215, bean.getAu1			());
			pstmt2.setString(216, bean.getAu2			());
			pstmt2.setString(217, bean.getAu3			());
			pstmt2.setString(218, bean.getAu4			());
			pstmt2.setString(219, bean.getAu5			());
			pstmt2.setString(220, bean.getAu6			());
			
			pstmt2.setString(221, bean.getAv1			());
			pstmt2.setString(222, bean.getAv2			());
			pstmt2.setString(223, bean.getAv3			());
			pstmt2.setString(224, bean.getAv4			());
			pstmt2.setString(225, bean.getAv5			());
			pstmt2.setString(226, bean.getAv6			());

			pstmt2.setString(227, bean.getAw1			());
			pstmt2.setString(228, bean.getAw2			());
			pstmt2.setString(229, bean.getAw3			());
			pstmt2.setString(230, bean.getAw4			());
			pstmt2.setString(231, bean.getAw5			());
			pstmt2.setString(232, bean.getAw6			());
			
			pstmt2.setString(233, bean.getAx1			());
			pstmt2.setString(234, bean.getAx2			());
			pstmt2.setString(235, bean.getAx3			());
			pstmt2.setString(236, bean.getAx4			());
			pstmt2.setString(237, bean.getAx5			());
			pstmt2.setString(238, bean.getAx6			());
			
			pstmt2.setString(239, bean.getAy1			());
			pstmt2.setString(240, bean.getAy2			());
			pstmt2.setString(241, bean.getAy3			());
			pstmt2.setString(242, bean.getAy4			());
			pstmt2.setString(243, bean.getAy5			());
			pstmt2.setString(244, bean.getAy6			());

			pstmt2.setString(245, bean.getDist			());
			pstmt2.setString(246, bean.getRm_st			());
			pstmt2.setString(247, bean.getRm_cont		());

			pstmt2.setString(248, bean.getFirm_nm		());
			pstmt2.setString(249, bean.getMng_id		());

			pstmt2.setString(250, bean.getMng_check		());
			pstmt2.setString(251, bean.getMng_check_dt	());
			pstmt2.setString(252, bean.getMng_id2		());

			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Car_checkDatabase:input_carcheck]\n"+e);

			System.out.println("[bean.getCheck_no		()]\n"+bean.getCheck_no		());
			System.out.println("[bean.getOff_id			()]\n"+bean.getOff_id		());
			System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm		());
			System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id		());
			System.out.println("[bean.getReg_dt			()]\n"+bean.getReg_dt		());
			System.out.println("[bean.getCar_mng_id		()]\n"+bean.getCar_mng_id	());
			System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
			System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
			System.out.println("[bean.getRent_s_cd		()]\n"+bean.getRent_s_cd	());
			System.out.println("[bean.getDriver_nm		()]\n"+bean.getDriver_nm	());
			System.out.println("[bean.getDriver_tel		()]\n"+bean.getDriver_tel	());


			e.printStackTrace();
	  		flag = false;
			check_no = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return check_no;
		}
	}


//운행차점검현황 리스트 조회
	public Vector getCarcheckMngList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.CHECK_NO, a.OFF_NM, a.OFF_ID, a.DRIVER_NM, a.DRIVER_TEL, TO_CHAR(a.REG_DT, 'YYYYMMDD') AS reg_dt, \n"+
				" TO_CHAR(a.pay_dt, 'YYYYMMDD') AS pay_dt,  TO_CHAR(a.mng_check_dt, 'YYYYMMDD') AS mng_check_dt, a.firm_nm, \n"+
				" decode(a.mng_check,'Y','확인','미확인') as mng_check, b.car_no, c.USER_NM AS user_nm1, d.user_nm AS user_nm2, c.br_id  \n"+ 
				" from car_check a, car_reg b, users c, users d \n"+
				" where a.car_mng_id = b.car_mng_id  \n"+
				" and a.mng_id = c.user_id and a.mng_id2 = d.user_id \n";


		String dt1 = "to_char(a.REG_DT,'YYYYMMDD')";
		String dt2 = "to_char(a.REG_DT,'YYYYMMDD')";

		if(gubun1.equals("1"))			query += " and "+dt1+" like to_char(sysdate,'YYYYMM')||'%' ";
		else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	query += " and a.driver_nm like '%"+t_wd+"%' ";	
		if(s_kd.equals("2"))	query += " and a.off_nm like '%"+t_wd+"%' ";	
		if(s_kd.equals("4"))	query += " and b.car_no like '%"+t_wd+"%'";	
		if(s_kd.equals("3"))	query += " and c.user_nm like '%"+t_wd+"%'";
		if(s_kd.equals("5"))	query += " and a.firm_nm like '%"+t_wd+"%'";
		
		if(gubun2.equals(""))			query += " ";
		else if(gubun2.equals("1"))		query += " and a.pay_dt is null ";
		else if(gubun2.equals("2"))		query += " and a.pay_dt is not null ";

		if(gubun3.equals(""))			query += " ";
		else if(gubun3.equals("2"))		query += " and a.mng_check is null ";
		else if(gubun3.equals("1"))		query += " and a.mng_check is not null ";


		query += " order by  decode(a.mng_check,'Y','확인','미확인'), a.check_no";


		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
//			System.out.println("[Car_checkDatabase:getCarcheckMngList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getCarcheckMngList]\n"+e);
			System.out.println("[Car_checkDatabase:getCarcheckMngList	]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

// 협력업체 운전자 조회
	
	public Vector getManSearch3(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct '운전자' gubun, driver_nm  nm, '' title, '' tel, replace(driver_m_tel,'-','') as m_tel from CONSIGNMENT where driver_nm is not null and substr(reg_dt,1,8) > to_char(add_months(sysdate,-1),'YYYYMMDD')";

		if(!t_wd.equals(""))		query += " and off_nm like '%"+t_wd+"%'";

		query += " order by driver_nm";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getManSearch3]\n"+e);
			System.out.println("[Car_checkDatabase:getManSearch3]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		

	}

	//청구서작성 리스트 조회
	public Vector getCarcheckReqlist(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String gubun3, String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.car_mng_id, b.car_no, c.user_id, c.br_id from car_check a, car_reg b, users c where a.car_mng_id = b.car_mng_id and a.reg_id = c.user_id ";


		query += " order by a.reg_dt";
//System.out.println("[Car_checkDatabase:getCarcheckReqlist]\n"+query);

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getCarcheckReqlist]\n"+e);
			System.out.println("[Car_checkDatabase:getCarcheckReqlist]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	 //한건 조회
	 	
  public Hashtable  getCarcheck_view(String check_no)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " SELECT a.*, b.car_no, B.CAR_NM, b.CAR_Y_FORM, c.colo, d.user_nm FROM car_check a, car_reg b, CAR_ETC c, users d "+
				" WHERE a.car_mng_id = b.car_mng_id AND a.RENT_MNG_ID = c.RENT_MNG_ID AND a.RENT_L_CD = c.RENT_L_CD and a.mng_id = d.user_id and  a.check_no = '"+check_no+"' ";


	  
		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getCarcheck_view]\n"+e);			
			System.out.println("[Car_checkDatabase:getCarcheck_view]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}

//결재완료 pay_dt 입력

	public boolean updateCar_checkPay_dt(String check_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_check set pay_dt=sysdate where check_no=?";

//System.out.println("updateCar_checkPay_dt: "+check_no);

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  check_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Car_checkDatabase:updateCar_checkPay_dt]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


//운행차점검 한건 삭제
public boolean deleteCarcheck(String check_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from car_check where check_no=?";
		String query2 =  " delete from doc_settle where doc_st='71' and doc_id=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  check_no);
			pstmt.executeUpdate();	
			
			pstmt = conn.prepareStatement(query2);		
			pstmt.setString(1,  check_no);
			pstmt.executeUpdate();	

			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Car_checkDatabase:deleteCarcheck]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

//보유차현황 차량상태에 운전자, 탁송업체, 전화번호 보여주기.
 public Hashtable  getCarInfo(String c_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " SELECT b.off_nm, b.DRIVER_NM, b.DRIVER_TEL FROM CAR_REG a, CAR_CHECK b WHERE a.CAR_MNG_ID = b.CAR_MNG_ID "+
				" AND a.CHECK_DT = TO_CHAR(b.reg_dt,'YYYYMMDD') and a.car_mng_id = '"+c_id+"' ";

      
		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getCarInfo]\n"+e);			
			System.out.println("[Car_checkDatabase:getCarInfo]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}

//보유차에서 날짜별로 보기 클릭시

public Vector getCheck_list(String c_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";

		query = " select check_no, TO_CHAR(reg_dt, 'YYYYMMDD') AS REG_DT from car_check where car_mng_id= '"+c_id+"' ";


		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ClientMngDatabase:getCheck_list]\n"+e);
			System.out.println("[ClientMngDatabase:getCheck_list]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


//담당자 확인완료 

	public boolean updateCar_check_Mngyn(String check_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_check set mng_check = 'Y', mng_check_dt=sysdate where check_no=?";

//System.out.println("updateCar_check_Mngyn: "+check_no);

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  check_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[Car_checkDatabase:updateCar_check_Mngyn]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


//차량관리 번호로 메신져로 메세지 받을 차량 담당자 ID 가져오기
	 	
  public Hashtable  getmng_id(String car_mng_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		//cont table rent_dt 기준으로 순위를 정하고 그중에 1순위에 해당하는 MNG_ID 보여주기
		query = "SELECT * FROM (SELECT RANK() OVER(PARTITION BY car_mng_id ORDER BY rent_dt DESC) AS rank, cont.mng_id FROM CONT WHERE car_mng_id =  '"+car_mng_id+"' ) WHERE rank ='1'";

      
		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getmng_id]\n"+e);			
			System.out.println("[Car_checkDatabase:getmng_id]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}



//운행차점검현황 리스트 조회
	public Vector getDriver_nm_listS(String s_kd, String t_wd, String gubun1, String st_year, String st_mon, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.DRIVER_NM, a.OFF_NM, c.BR_ID, count(a.check_no) cnt0,  2000 *  count(a.check_no) samt "+
				" FROM car_check a, car_reg b, USERS c "+
				" WHERE a.off_nm = c.USER_nm(+) "+
				" and a.car_mng_id = b.car_mng_id(+)  and a.off_nm ='전국' ";

		query += " and to_char(a.REG_DT,'YYYY') = '"+st_year+"' ";

		if(!st_mon.equals("")) query += " AND  to_number(substr(to_char(a.REG_DT,'YYYYMMDD'),5,2)) = '"+st_mon+"' ";

		if(!t_wd.equals("")) {
			if(s_kd.equals("1"))	query += " and a.driver_nm like '%"+t_wd+"%' ";	
			if(s_kd.equals("2"))	query += " and a.off_nm like '%"+t_wd+"%' ";	
			if(s_kd.equals("4"))	query += " and b.car_no like '%"+t_wd+"%' ";		
			if(s_kd.equals("3"))	query += " and c.user_nm like '%"+t_wd+"%' ";	
			if(s_kd.equals("5"))	query += " and a.firm_nm like '%"+t_wd+"%' ";	
		}
			
		if(gubun2.equals(""))			query += " ";
		else if(gubun2.equals("1"))		query += " and a.pay_dt is null ";
		else if(gubun2.equals("2"))		query += " and a.pay_dt is not null ";

		if(gubun3.equals(""))			query += " ";
		else if(gubun3.equals("2"))		query += " and a.mng_check is null ";
		else if(gubun3.equals("1"))		query += " and a.mng_check is not null ";


		query += " GROUP BY a.DRIVER_NM, a.OFF_NM, c.BR_ID ";

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
//			System.out.println("[Car_checkDatabase:getCarcheckMngList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getCarcheckMngList]\n"+e);
			System.out.println("[Car_checkDatabase:getCarcheckMngList	]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

//운행차점검현황 리스트 조회
	public Vector getDriver_nm_listB(String s_kd, String t_wd, String gubun1, String st_year, String st_mon, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.DRIVER_NM, a.OFF_NM, c.BR_ID, count(a.check_no) cnt0,  2000 *  count(a.check_no) samt "+
				" FROM car_check a, car_reg b, USERS c "+
				" WHERE a.MNG_ID = c.USER_ID "+
				" and a.car_mng_id = b.car_mng_id and a.off_nm = '하이카콤(부산)' ";

		query += " and to_char(a.REG_DT,'YYYY')= '"+st_year+"' ";

		if(!st_mon.equals("")) query += " AND  to_number(substr(to_char(a.REG_DT,'YYYYMMDD'),5,2)) = '"+st_mon+"' ";

		if(!t_wd.equals("")) {
			if(s_kd.equals("1"))	query += " and a.driver_nm like '%"+t_wd+"%' ";	
			if(s_kd.equals("2"))	query += " and a.off_nm like '%"+t_wd+"%' ";	
			if(s_kd.equals("4"))	query += " and b.car_no like '%"+t_wd+"%' ";		
			if(s_kd.equals("3"))	query += " and c.user_nm like '%"+t_wd+"%' ";	
			if(s_kd.equals("5"))	query += " and a.firm_nm like '%"+t_wd+"%' ";	
		}
			
		if(gubun2.equals(""))			query += " ";
		else if(gubun2.equals("1"))		query += " and a.pay_dt is null ";
		else if(gubun2.equals("2"))		query += " and a.pay_dt is not null ";

		if(gubun3.equals(""))			query += " ";
		else if(gubun3.equals("2"))		query += " and a.mng_check is null ";
		else if(gubun3.equals("1"))		query += " and a.mng_check is not null ";

		query += " GROUP BY a.DRIVER_NM, a.OFF_NM, c.BR_ID ";

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
//			System.out.println("[Car_checkDatabase:getCarcheckMngList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getCarcheckMngList]\n"+e);
			System.out.println("[Car_checkDatabase:getCarcheckMngList	]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	//운행차점검현황 리스트 조회
	public Vector getDriver_nm_listD(String s_kd, String t_wd, String gubun1, String st_year, String st_mon, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.DRIVER_NM, a.OFF_NM, c.BR_ID, count(a.check_no) cnt0,  2000 *  count(a.check_no) samt "+
				" FROM car_check a, car_reg b, USERS c "+
				" WHERE a.MNG_ID = c.USER_ID "+
				" and a.car_mng_id = b.car_mng_id and off_nm = '하이카콤(대전)' ";

		query += " and to_char(a.REG_DT,'YYYY') = '"+st_year+"' ";

		if(!st_mon.equals("")) query += " AND  to_number(substr(to_char(a.REG_DT,'YYYYMMDD'),5,2)) = '"+st_mon+"' ";

		if(s_kd.equals("1"))	query += " and upper(nvl(a.driver_nm, ' ')) like replace('%"+t_wd+"%', '-','') ";	
		if(s_kd.equals("2"))	query += " and upper(nvl(a.off_nm, ' ')) like replace('%"+t_wd+"%', '-','') ";	
		if(s_kd.equals("4"))	query += " and upper(nvl(b.car_no, ' ')) like replace('%"+t_wd+"%', '-','')";	
		if(s_kd.equals("3"))	query += " and upper(nvl(c.user_nm, ' ')) like replace('%"+t_wd+"%', '-','')";
		if(s_kd.equals("5"))	query += " and upper(nvl(a.firm_nm, ' ')) like replace('%"+t_wd+"%', '-','')";
		
		if(gubun2.equals(""))			query += " ";
		else if(gubun2.equals("1"))		query += " and a.pay_dt is null ";
		else if(gubun2.equals("2"))		query += " and a.pay_dt is not null ";

		if(gubun3.equals(""))			query += " ";
		else if(gubun3.equals("2"))		query += " and a.mng_check is null ";
		else if(gubun3.equals("1"))		query += " and a.mng_check is not null ";

		query += " GROUP BY a.DRIVER_NM, a.OFF_NM, c.BR_ID ";

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
//			System.out.println("[Car_checkDatabase:getCarcheckMngList]\n"+query);
		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getCarcheckMngList]\n"+e);
			System.out.println("[Car_checkDatabase:getCarcheckMngList	]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


public int insertCar_stat(String user_id, String car_stat)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";

		query = " insert into CAR_STANDARD (reg_id, reg_dt, car_stat)values('"+user_id+"', to_char(sysdate,'YYYYMMddhh24miss'), '"+car_stat+"')";

//System.out.println("[Car_checkDatabase:insertCar_stat]\n"+query);
		try 
		{			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:insertCar_stat]\n"+e);
			System.out.println("[Car_checkDatabase:insertCar_stat]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[Car_checkDatabase:insertCar_stat]\n"+e);
			System.out.println("[Car_checkDatabase:insertCar_stat]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}

//점검기춘 가장 최근것 보여주기
 public Hashtable  getCar_Standard()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " SELECT a.car_stat, a.reg_dt FROM car_standard a, (SELECT MAX(reg_dt) reg_dt FROM CAR_STANDARD) b WHERE a.REG_DT = b.reg_dt  ";

      
		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		      		
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[Car_checkDatabase:getCar_Standard]\n"+e);			
			System.out.println("[Car_checkDatabase:getCar_Standard]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}



}

