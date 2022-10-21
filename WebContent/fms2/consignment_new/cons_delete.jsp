<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="cl_bean" class="acar.consignment.ConsignmentLinkBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	int result = 0;
	
	
%>


<%
	String reg_code	 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String req_code	 	= request.getParameter("req_code")==null?"":request.getParameter("req_code");
	String cons_no	 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String del_seq	 	= request.getParameter("del_seq")==null?"":request.getParameter("del_seq");
	
	out.println(cons_no+"<br>");
	
	if(mode.equals("all")){
		
		//=====[consignment] update=====
		flag1 = cs_db.deleteConsignments(cons_no);
		out.println("탁송의뢰 삭제<br>");
		
		//채권양도 통지서 및 위임장 이 있으면 삭제
		Vector bond_trf_doc = cs_db.getBond_trf_doc(cons_no);
		int bond_trf_doc_size = bond_trf_doc.size();
		if(bond_trf_doc_size > 0){
			flag4 = cs_db.deleteBond_trf_doc(cons_no);
		}
		
		// 에스폼 인도인수증 임시 저장 문서 있으면 삭제 20210624
		Vector vt = cs_db.getRegistedConsignmentLinkList(cons_no);
		int vt_size = vt.size();
		
		if( vt_size > 0 ){
			String new_tmsg_seq  = "";
			
			for(int i = 0; i<vt_size; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String prev_tmsg_seq = String.valueOf(ht.get("TMSG_SEQ"));	// 기존 tmsg_seq

				new_tmsg_seq = Long.toString(System.currentTimeMillis());	// 새 tmsg_seq
				
				cl_bean.setCons_no(cons_no);
				cl_bean.setTmsg_seq(new_tmsg_seq);
				cl_bean.setCons_yn("D");
				
				flag7 = cs_db.updateConsignment_link(cl_bean, "AC102", prev_tmsg_seq);
				
			}
		}
	}
	else if(mode.equals("case")){
		//=====[consignment] update=====
		flag1 = cs_db.deleteConsignment(cons_no, AddUtil.parseInt(del_seq));
		out.println(del_seq+"번 탁송의뢰 삭제<br>");
	}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('탁송 삭제 에러입니다.\n\n확인하십시오');					<%		}	%>		
<%-- <%		if(!flag2){	%>	alert('문서품의서 등록 에러입니다.\n\n확인하십시오');			<%		}	%>		
<%		if(!flag3){	%>	alert('쿨메신저 등록 에러입니다.\n\n확인하십시오');				<%		}	%> --%>
<%		if(!flag4){	%>	alert('채권양도통지서 및 위임장 삭제 에러입니다.\n\n확인하십시오');				<%		}	%>	
<%		if(!flag7){	%>	alert('인도인수증 임시 저장 문서 삭제 에러입니다.\n\n확인하십시오');				<%		}	%>	
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">  
  <input type='hidden' name='cons_no' 			value='<%=cons_no%>'>    
</form>
<script language='javascript'>
	var fm = document.form1;	
	
	
	<%if(mode.equals("case")){%>
	fm.action = 'cons_reg_step2.jsp';
	<%}else{%>
	if(fm.from_page.value == ''){
		fm.action = 'cons_rec_frame.jsp';
	}else{
		fm.action = fm.from_page.value;
	}	
	<%}%>
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>