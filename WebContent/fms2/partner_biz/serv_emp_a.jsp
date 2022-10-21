<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*, acar.partner.*, acar.pay_mng.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="emp_Bn" class="acar.partner.Serv_EmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	int count = 0;
	int count2 = 0;
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String off_nm = request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String off_st = request.getParameter("off_st")==null?"":request.getParameter("off_st");
	String off_tel = request.getParameter("off_tel")==null?"":request.getParameter("off_tel");
	String off_post = request.getParameter("off_post")==null?"":request.getParameter("off_post");
	String off_addr = request.getParameter("off_addr")==null?"":request.getParameter("off_addr");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String bank = request.getParameter("bank")==null?"":request.getParameter("bank");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String acc_no = request.getParameter("acc_no")==null?"":request.getParameter("acc_no");
	String acc_nm = request.getParameter("acc_nm")==null?"":request.getParameter("acc_nm");
	String acc_note = request.getParameter("acc_note")==null?"":request.getParameter("acc_note");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String close_dt = request.getParameter("close_dt")==null?"":request.getParameter("close_dt");
	String deal_note = request.getParameter("deal_note")==null?"":request.getParameter("deal_note");
	String gubun_b 	= request.getParameter("gubun_b")==null?"":request.getParameter("gubun_b");
	String off_type 	= request.getParameter("off_type")==null?"1":request.getParameter("off_type");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String emp_nm 	= request.getParameter("emp_nm")==null?"":request.getParameter("emp_nm");

	int seq = request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String dept_nm 	= request.getParameter("dept_nm")==null?"":request.getParameter("dept_nm");
	String pos 	= request.getParameter("pos")==null?"":request.getParameter("pos");
	String emp_level 	= request.getParameter("emp_level")==null?"":request.getParameter("emp_level");
	String emp_tel 	= request.getParameter("emp_tel")==null?"":request.getParameter("emp_tel");
	String emp_htel 	= request.getParameter("emp_htel")==null?"":request.getParameter("emp_htel");
	String emp_fax 	= request.getParameter("emp_fax")==null?"":request.getParameter("emp_fax");
	String emp_mtel 	= request.getParameter("emp_mtel")==null?"":request.getParameter("emp_mtel");
	String emp_email 	= request.getParameter("emp_email")==null?"":request.getParameter("emp_email");
	String emp_role 	= request.getParameter("emp_role")==null?"":request.getParameter("emp_role");
	String emp_valid 	= request.getParameter("emp_valid")==null?"":request.getParameter("emp_valid");
	String emp_addr 	= request.getParameter("emp_addr")==null?"":request.getParameter("emp_addr");
	String emp_post 	= request.getParameter("emp_post")==null?"":request.getParameter("emp_post");
	
//	String emp_email_yn 	= request.getParameter("emp_email_yn")==null?"":request.getParameter("emp_email_yn");
	
	off_st = "7";
	String text = "";
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	if(cmd.equals("off_i")){//회사등록
		//협력업체 등록중복 확인
		Hashtable ht = se_dt.getServOffChk(off_nm);
		
		if(ht.size()!=0){
			text = "이미 등록된 상호명이 있습니다. 확인해주세요.";
			count = 0;
		}else{
			if(!bank_id.equals("")){
				bank_id = bank.substring(0,4);
			}
			c61_soBn.setCar_comp_id(car_comp_id);  	//관리구분
			c61_soBn.setOff_nm(off_nm); 						//상호
			c61_soBn.setOff_st(off_st); 							//7
			c61_soBn.setBr_id(br_id); 							//본점/지점
			c61_soBn.setOff_tel(off_tel); 						//대표전화
			c61_soBn.setOff_post(off_post); 					//우편번호
			c61_soBn.setOff_addr(off_addr); 					//주소
			c61_soBn.setAcc_no(acc_no);						//계좌번호
			c61_soBn.setAcc_note(acc_note);					//적요
			c61_soBn.setNote(note);								//거래내용
			c61_soBn.setReg_id(user_id);						//등록자
			c61_soBn.setStart_dt(start_dt);					//최초거래개시일자
			c61_soBn.setClose_dt(close_dt);					//거래종료일자
			c61_soBn.setDeal_note(deal_note);				//비고
			c61_soBn.setGubun_b(gubun_b);					//금융사 구분(1=은행, 2=저축은행, 3=캐피탈, 4=카드)
			
			count = se_dt.insertServOff(c61_soBn, bank_id);
			
			/*
               20200420 금융사 코드관리 추가할 필요가 없다.
			//금융사연락처는 코드도 같이 관리(20190701)
			Hashtable ht2 = ps_db.getFinanceCode(off_nm);
			
			if(ht2.size()==0 && count==1){	//금융사 코드등록
				CodeBean c_bean = new CodeBean();
				c_bean.setC_st("0003");
				c_bean.setNm_cd(off_nm);
				c_bean.setNm(off_nm);
				String gubun_e = "";
				if(AddUtil.parseInt(gubun_b)>2){	gubun_e="3";}else{	gubun_e = gubun_b;		} 
				c_bean.setGubun(	gubun_e);
				boolean flag = ps_db.insertFinanceCode(c_bean);
				if(flag==false){
					count = 0;
					text = "금융사 코드등록 에러!";
				}
			}
			*/
		}
		
	}else if(cmd.equals("off_u")){//회사수정
	
		c61_soBn.setOff_id(off_id);  							//off_id
		c61_soBn.setCar_comp_id(car_comp_id);  	//관리구분
		c61_soBn.setOff_nm(off_nm); 						//상호
		c61_soBn.setOff_st(off_st); 							//7
		c61_soBn.setBr_id(br_id); 							//본점/지점
		c61_soBn.setOff_tel(off_tel); 						//대표전화
		c61_soBn.setOff_post(off_post); 					//우편번호
		c61_soBn.setOff_addr(off_addr); 					//주소
		c61_soBn.setNote(note);								//거래내용
		c61_soBn.setUpd_id(user_id);						//수정자
		c61_soBn.setStart_dt(start_dt);					//최초거래개시일자
		c61_soBn.setClose_dt(close_dt);					//거래종료일자
		c61_soBn.setDeal_note(deal_note);				//비고
		c61_soBn.setGubun_b(gubun_b);					//금융사 구분(1=은행, 2=저축은행, 3=캐피탈, 4=카드)
		c61_soBn.setCpt_cd(cpt_cd);					//금융사코드
		count = se_dt.updateServOff(c61_soBn);
	
	}else if(cmd.equals("emp_i")){//담당자등록
	
		emp_Bn.setOff_id(off_id);	
		emp_Bn.setEmp_nm(emp_nm);
		emp_Bn.setDept_nm(dept_nm);
		emp_Bn.setPos(pos);
		emp_Bn.setEmp_level(emp_level);
		emp_Bn.setEmp_tel(emp_tel);
		emp_Bn.setEmp_htel(emp_htel);
		emp_Bn.setEmp_fax(emp_fax);
		emp_Bn.setEmp_mtel(emp_mtel);
		emp_Bn.setEmp_email(emp_email.trim());
		emp_Bn.setEmp_role(emp_role);
		emp_Bn.setEmp_valid(emp_valid);
		emp_Bn.setEmp_addr(emp_addr);
		emp_Bn.setEmp_post(emp_post);
		emp_Bn.setEmp_email_yn("Y");	//수정(2018.04.03)
		
		count = se_dt.insertServEmp(emp_Bn);
		
	}else if(cmd.equals("emp_u")){ //담당자 수정

		emp_Bn.setOff_id(off_id);	
		emp_Bn.setSeq(seq);
		emp_Bn.setEmp_nm(emp_nm);
		emp_Bn.setDept_nm(dept_nm);
		emp_Bn.setPos(pos);
		emp_Bn.setEmp_level(emp_level);
		emp_Bn.setEmp_tel(emp_tel);
		emp_Bn.setEmp_htel(emp_htel);
		emp_Bn.setEmp_fax(emp_fax);
		emp_Bn.setEmp_mtel(emp_mtel);
		emp_Bn.setEmp_email(emp_email.trim());
		emp_Bn.setEmp_role(emp_role);
		emp_Bn.setEmp_valid(emp_valid);
		emp_Bn.setEmp_addr(emp_addr);
		emp_Bn.setEmp_post(emp_post);
		
		count = se_dt.updateServEmp(emp_Bn);
	}
%> 
	
<html>
<head>
<title>FMS</title>
</head>
<body>
<script language="JavaScript">
<!--
	//alert('<%=count%> : 처리결과 상태값');
	
<% if(count==1){ %>
	<%if(cmd.equals("emp_i")||cmd.equals("off_i") ){%>
	alert("정상적으로 등록되었습니다.");
	<%}else if(cmd.equals("emp_u")||cmd.equals("off_u")){%>
	alert("정상적으로 수정되었습니다.");
	<%}%>
	<%//if(from_page.equals("/fms2/partner_biz/serv_emp_frame.jsp")){%>
	parent.opener.location.reload();
	parent.close();
	<%//}%>
	
<% }else{ %>
	<%if(!text.equals("")){%>
		alert('<%=text%>');
	<%}else{%>
		alert("데이터베이스에 문제가 발생하였습니다.\n관리자님께 문의하세요!");
		parent.close();
	<%}%>
<% } %>
//-->
</script>
</body>
</html>