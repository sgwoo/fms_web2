<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.car_service.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");//사고관리번호
	String cust_req_dt =  request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"); //청구일자
	
	String item_id	 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");  //거래명세서
		
	int cust_s_amt 	=  request.getParameter("cust_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_s_amt")); //청구 공급가
	int cust_v_amt 	=  request.getParameter("cust_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_v_amt")); //청구 부가세
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();	
	
		
	AccidentBean accid = as_db.getAccidentBean(c_id, accid_id);
	
	int flag = 0;	
	int count = 0;
	boolean flag2 = true;
	boolean flag6 = true;
	
	String from_page 	= "";

		
	int c_amt = AddUtil.parseDigit(request.getParameter("cust_amt"));
	
	ServiceBean s_bean = a_csd.getService(c_id, accid_id, serv_id);
			
	s_bean.setCust_amt(request.getParameter("cust_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_amt")));
	s_bean.setCust_req_dt(request.getParameter("cust_req_dt")==null?"":request.getParameter("cust_req_dt"));
	s_bean.setCust_plan_dt(request.getParameter("cust_plan_dt")==null?"":request.getParameter("cust_plan_dt"));
	s_bean.setCust_pay_dt(request.getParameter("cust_pay_dt")==null?"":request.getParameter("cust_pay_dt"));  //해지정산후 입금된경우 입금일만 수정될 수 있음.
	s_bean.setUpdate_id(user_id);//수정자
	s_bean.setUpdate_dt(AddUtil.getDate());//수정일자
	s_bean.setExt_amt(request.getParameter("ext_amt")==null?0:AddUtil.parseDigit(request.getParameter("ext_amt"))); //고객입금액
	s_bean.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_s_amt"))); //해지정산시 포함금액
	s_bean.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_v_amt"))); //해지정산시 포함금액
	s_bean.setCls_amt(request.getParameter("cls_amt")==null?0:AddUtil.parseDigit(request.getParameter("cls_amt"))); //해지정산시 포함금액
	s_bean.setCust_s_amt(request.getParameter("cust_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_s_amt"))); //청구 공급가액
	s_bean.setCust_v_amt(request.getParameter("cust_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("cust_v_amt"))); //청구 부가세액
	s_bean.setExt_cau(request.getParameter("ext_cau")==null?"":request.getParameter("ext_cau"));//고객입금내역
		
		// 입금이 안된 건이고 정비가 없는 건에 한해서 삭제   - 거래명세서발행된건이면 거래명세서도 삭제
	if(!serv_id.equals("") && s_bean.getCust_pay_dt().equals("")){
			
		if(!a_csd.deleteServCust(c_id, serv_id))	flag += 1;			
		if(!a_csd.deleteServCustExt(m_id, l_cd, serv_id))	flag += 1;		
		
		if(!item_id.equals("")){  //거래명세서 발행건이면 거래명세서도 삭제
			if(!IssueDb.deleteTaxItem(item_id)) flag += 1;
		}		
   } 
	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>

<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="accid_id" value='<%=accid_id%>'>
<input type='hidden' name="serv_id" value='<%=serv_id%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//면책금 확정 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//면책금 확정 성공.. %>
	
    alert('처리되었습니다');
    fm.action = "accid_u_frame.jsp";		
	fm.target = "d_content";
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
