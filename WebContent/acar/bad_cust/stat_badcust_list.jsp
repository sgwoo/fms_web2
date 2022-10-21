<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bad_cust.*, acar.client.*"%>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String badcust_chk_from = request.getParameter("badcust_chk_from")==null?"":request.getParameter("badcust_chk_from");
	
	String bc_nm = "";
	String bc_ent_no = "";
	String bc_lic_no = "";
	String bc_firm_nm = "";
	String bc_m_tel = "";
	String bc_h_tel = "";
	String bc_o_tel = "";		
	String bc_email = "";
	String bc_fax = "";
	String bc_e_tel1 = "";
	String bc_e_tel2 = "";
	
	if(badcust_chk_from.equals("client_i.jsp")){
	
		String client_st  	= request.getParameter("client_st");
		String firm_nm[] 	= request.getParameterValues("firm_nm");
		String client_nm[] 	= request.getParameterValues("client_nm");
		String ssn1[] 		= request.getParameterValues("ssn1");
		String h_tel[] 		= request.getParameterValues("h_tel");
		String o_tel[] 		= request.getParameterValues("o_tel");
		String m_tel[] 		= request.getParameterValues("m_tel");
		String fax[] 		= request.getParameterValues("fax");

		//거래처 bean
		ClientBean client = new ClientBean();
		
		//법인
		if (client_st.equals("1") || client_st.equals("6")) {
			client.setFirm_nm		(firm_nm[0]);
			client.setClient_nm	(client_nm[0]);
			client.setSsn1			(ssn1[0]);
			client.setH_tel			(h_tel[0]);
			client.setO_tel			(o_tel[0]);
			client.setM_tel			(m_tel[0]);
			client.setFax				(fax[0]);
		//개인사업자
		} else if (client_st.equals("3") || client_st.equals("4") || client_st.equals("5")) {
			client.setFirm_nm		(firm_nm[1]);
			client.setClient_nm	(client_nm[1]);
			client.setSsn1			(ssn1[1]);
			client.setH_tel			(h_tel[1]);
			client.setO_tel			(o_tel[1]);
			client.setM_tel			(m_tel[1]);
			client.setFax				(fax[1]);
		//개인
		} else if (client_st.equals("2")) {   //자택주소
			client.setFirm_nm		(firm_nm[2]);
			client.setClient_nm	(firm_nm[2]);
			client.setSsn1			(ssn1[2]);
			client.setH_tel			(h_tel[2]);
			client.setO_tel			(o_tel[2]);
			client.setM_tel			(m_tel[2]);
			client.setFax				(fax[2]);
		}
		
		client.setCon_agnt_email	(request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email").trim());
		client.setLic_no					(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));
		
		bc_nm 		= client.getClient_nm();
		bc_ent_no = client.getSsn1();
		bc_lic_no = client.getLic_no();
		bc_firm_nm= client.getFirm_nm();
		bc_m_tel 	= client.getM_tel();
		bc_h_tel 	= client.getH_tel();
		bc_o_tel 	= client.getO_tel();
		bc_email 	= client.getCon_agnt_email();
		bc_fax 		= client.getFax();

	}else if(badcust_chk_from.equals("esti_mng_atype_i.jsp") || badcust_chk_from.equals("esti_mng_i_20090901.jsp")){
		
		bc_nm = request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
		bc_m_tel = request.getParameter("est_tel")==null?"":request.getParameter("est_tel");
		bc_email = request.getParameter("est_mail")==null?"":request.getParameter("est_mail");
		bc_fax = request.getParameter("est_fax")==null?"":request.getParameter("est_fax");
		
		bc_firm_nm = bc_nm;
		
	}else if(badcust_chk_from.equals("esti_spe_hp_i.jsp")){
		
		bc_nm = request.getParameter("est_nm")==null?"":request.getParameter("est_nm");
		bc_lic_no = request.getParameter("lic_no")==null?"":request.getParameter("lic_no");
		bc_m_tel = request.getParameter("est_tel")==null?"":request.getParameter("est_tel");
		bc_o_tel = request.getParameter("est_o_tel")==null?"":request.getParameter("est_o_tel");
		bc_h_tel = request.getParameter("est_comp_tel")==null?"":request.getParameter("est_comp_tel");
		bc_email = request.getParameter("est_mail")==null?"":request.getParameter("est_mail");
		bc_fax = request.getParameter("est_fax")==null?"":request.getParameter("est_fax");
		bc_e_tel1 = request.getParameter("est_comp_cel")==null?"":request.getParameter("est_comp_cel");
		bc_e_tel2 = request.getParameter("driver_cell")==null?"":request.getParameter("driver_cell");
		bc_firm_nm = bc_nm;		
	
	}else if(badcust_chk_from.equals("lc_rm_conform.jsp")){	

		bc_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
		bc_firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		bc_ent_no = request.getParameter("ssn1")==null?"":request.getParameter("ssn1");
		
	}
	
	/*
	out.println("bc_nm"+bc_nm+" ");	
	out.println("bc_ent_no"+bc_ent_no+" ");	
	out.println("bc_lic_no"+bc_lic_no+" ");	
	out.println("bc_firm_nm"+bc_firm_nm+" ");	
	out.println("bc_m_tel"+bc_m_tel+" ");	
	out.println("bc_h_tel"+bc_h_tel+" ");	
	out.println("bc_o_tel"+bc_o_tel+" ");	
	out.println("bc_email"+bc_email+" ");	
	out.println("bc_fax"+bc_fax+" ");	
	*/
	
	//불량고객 확인
	Vector vt_chk1 = bc_db.getBadCustRentCheck(bc_firm_nm, bc_nm, bc_ent_no, bc_lic_no, bc_m_tel, bc_h_tel, bc_o_tel, bc_email, bc_fax, bc_e_tel1, bc_e_tel2);
	int vt_chk1_size = vt_chk1.size(); 
	
	Vector custs = bc_db.getBadCustAll("", "");
	int cust_size = custs.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	function save(){
		
		var ofm = opener.document.form1;
		
		ofm.badcust_chk.value = 'Y';
		
		self.moveTo(0,0); 
		
		<%if(badcust_chk_from.equals("client_i.jsp")){%>
			//opener.save();
		<%}else if(badcust_chk_from.equals("esti_mng_atype_i.jsp")){%>
			//opener.EstiReg();
			//opener.confirmDialog();
		<%}else if(badcust_chk_from.equals("lc_rm_conform.jsp")){%>			
			//opener.update();
		<%}%>
		
		self.close();
	}		
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width=1580>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 고객관리 > <span class=style5>불량고객 리스트</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td colspan=2 class=h></td>
    </tr>
    <tr>
        <td colspan=2>※ 불량고객으로 등록된 고객과 동일인지 여부를 확인 후 진행하시기 바랍니다.</td>
    </tr>     
    <tr>
        <td colspan=2>&nbsp;&nbsp;<font color=red>(상호:<%=bc_firm_nm%>/성명:<%=bc_nm%>/생년월일:<%=bc_ent_no%>/운전면허번호:<%=bc_lic_no%>/휴대폰번호:<%=bc_m_tel%>/이메일주소:<%=bc_email%>/FAX:<%=bc_fax%>... 중 1개라도 일치하면 나오는 멘트이니 동일인 인지 확인바랍니다.)</font></td>
    </tr> 
    <tr>
        <td colspan=2 class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='370' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>                     
                    <td width=40 class=title>연번</td>		  
                    <td width=80 class=title>등록일자</td>		  
                    <td width=150 class=title>성명</td>		  
                    <td width=100 class=title>생년월일</td>		  
				</tr>
			</table>
		</td>
		<td class='line' width='1210'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>                    
                    <td width=150 class=title>주소</td>
                    <td width=110 class=title>운전면허번호</td>
                    <td width=100 class=title>휴대폰번호</td>
                    <td width=150 class=title>이메일주소</td>
                    <td width=100 class=title>FAX</td>
                    <td width=200 class=title>피해업체</td>
                    <td width=400 class=title>피해내용</td>
				</tr>
			</table>
		</td>
	</tr>
  <%if(vt_chk1_size > 0){%>
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<%
        			for(int i = 0 ; i < vt_chk1_size ; i++){
        				Hashtable cust = (Hashtable)vt_chk1.elementAt(i);%>
                <tr> 
                    <td width=40 align=center><%=i+1%></td>
                    <td width=80 align=center><%=AddUtil.ChangeDate2(String.valueOf(cust.get("REG_DT")))%></td>
                    <td width=150 align=center><%=cust.get("BC_NM")%></td>
                    <td width=100 align=center><%=AddUtil.ChangeEnpH(String.valueOf(cust.get("BC_ENT_NO")))%></td>
                </tr>
                <%	}%>
			</table>
		</td>
		<td class='line' width='1210'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
        		<%
        			for(int i = 0 ; i < vt_chk1_size ; i++){
        				Hashtable cust = (Hashtable)vt_chk1.elementAt(i);%>
                <tr> 
                    <td width=150>&nbsp;<span title='<%=cust.get("BC_ADDR")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_ADDR")), 22)%></span></td>
                    <td width=110 align=center><%=cust.get("BC_LIC_NO")%> </td>
                    <td width=100 align=center><%=cust.get("BC_M_TEL")%></td>
                    <td width=150 align=center><%=cust.get("BC_EMAIL")%> </td>
                    <td width=100 align=center><%=cust.get("BC_FAX")%></td>
                    <td width=200>&nbsp;<span title='<%=cust.get("BC_FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_FIRM_NM")), 30)%></span></td>
                    <td width=400>&nbsp;<span title='<%=cust.get("BC_CONT")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_CONT")), 65)%></span></td>
                </tr>
                <%	}%>
			</table>
		</td>                
	</tr>                                
  <%}else{%>
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='1210'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
  <%}%>
				<tr>
					<td colspan='2'>&nbsp;</td>
				</tr>  
    <tr> 
        <td colspan='2' align='center'>
        	<%//if(!badcust_chk_from.equals("") && !badcust_chk_from.equals("esti_spe_hp_i.jsp")&& !badcust_chk_from.equals("esti_mng_i_20090901.jsp") && vt_chk1_size > 0){%>
        	<a href="javascript:save();"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>
        	&nbsp;&nbsp;&nbsp;&nbsp;
        	<%//}%>
        	<a href='javascript:window.close()'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a> 
        </td>
    </tr>  
				<tr>
					<td colspan='2'><hr></td>
				</tr>      
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='370' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>                     
                    <td width=40 class=title>연번</td>		  
                    <td width=80 class=title>등록일자</td>		  
                    <td width=150 class=title>성명</td>		  
                    <td width=100 class=title>생년월일</td>		  
				</tr>
			</table>
		</td>
		<td class='line' width='1210'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>                    
                    <td width=150 class=title>주소</td>
                    <td width=110 class=title>운전면허번호</td>
                    <td width=100 class=title>휴대폰번호</td>
                    <td width=150 class=title>이메일주소</td>
                    <td width=100 class=title>FAX</td>
                    <td width=200 class=title>피해업체</td>
                    <td width=400 class=title>피해내용</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<%
        			for(int i = 0 ; i < cust_size ; i++){
        				Hashtable cust = (Hashtable)custs.elementAt(i);%>
                <tr> 
                    <td width=40 align=center><%=i+1%></td>
                    <td width=80 align=center><%=AddUtil.ChangeDate2(String.valueOf(cust.get("REG_DT")))%></td>
                    <td width=150 align=center><%=cust.get("BC_NM")%></td>
                    <td width=100 align=center><%=AddUtil.ChangeEnpH(String.valueOf(cust.get("BC_ENT_NO")))%></td>
                </tr>
                <%	}%>
			</table>
		</td>
		<td class='line' width='1210'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
        		<%
        			for(int i = 0 ; i < cust_size ; i++){
        				Hashtable cust = (Hashtable)custs.elementAt(i);%>
                <tr> 
                    <td width=150>&nbsp;<span title='<%=cust.get("BC_ADDR")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_ADDR")), 22)%></span></td>
                    <td width=110 align=center><%=cust.get("BC_LIC_NO")%> </td>
                    <td width=100 align=center><%=cust.get("BC_M_TEL")%></td>
                    <td width=150 align=center><%=cust.get("BC_EMAIL")%> </td>
                    <td width=100 align=center><%=cust.get("BC_FAX")%></td>
                    <td width=200>&nbsp;<span title='<%=cust.get("BC_FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_FIRM_NM")), 30)%></span></td>
                    <td width=400>&nbsp;<span title='<%=cust.get("BC_CONT")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_CONT")), 65)%></span></td>
                </tr>
                <%	}%>
			</table>
		</td>                
	</tr>                                
    
</table>
</body>
<script language='javascript'>
	<%if(vt_chk1_size == 0){%>
		//save();
	<%}%>
</script>
</html>
