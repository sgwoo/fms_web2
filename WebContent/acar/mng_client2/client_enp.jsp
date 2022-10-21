<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.bill_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_modify()
	{
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "client_u.jsp";		
		fm.submit();
//		location='/acar/mng_client2/client_u.jsp?client_id='+client_id+'&auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
	}
	
	function view_car_mgr(rent_mng_id, rent_l_cd)
	{
		var fm = document.form1;
		fm.action='/acar/mng_client2/car_mgr_in.jsp?rent_mng_id='+rent_mng_id+'&rent_l_cd='+rent_l_cd;
		fm.target='inner2';
		fm.submit();
	}
	
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var t_wd = fm.t_wd.value;
		var asc = fm.asc.value;
		location='/acar/mng_client2/client_s_frame.jsp?auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
	}
	//지점/현장관리
	function cl_site(client_id, firm_nm)
	{
		window.open('/acar/mng_client2/client_site_s_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_SITE", "left=100, top=100, width=650, height=500, scrollbars=yes");
	}
	//사업장등록증이력
	function cl_enp_h(client_id, firm_nm)
	{
		var fm = document.form1;
		window.open("about:blank", "CLIENT_ENP", "left=50, top=50, width=900, height=500, scrollbars=yes");				
		fm.action = "client_enp_p.jsp";
		fm.target = "CLIENT_ENP";
		fm.submit();
//		window.open('/acar/mng_client2/client_enp_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_ENP", "left=100, top=100, width=900, height=500, scrollbars=yes");
	}	
	function add_site(idx, val, str){
		document.form1.t_r_site[idx] = new Option(str, val);		
	}				
	function drop_site(){
		var fm = document.form1;
		var site_len = fm.t_r_site.length;
		for(var i = 0 ; i < site_len ; i++){
			fm.t_r_site.options[site_len-(i+1)] = null;
		}
	}	
	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
		
	
	ClientBean client = al_db.getNewClient(client_id);
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	Vector c_sites = al_db.getClientSites(client_id);
	int c_site_size = c_sites.size();
	
	//네오엠 거래처 정보
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable ven = new Hashtable();
	if(!client.getVen_code().equals("")){
		ven = neoe_db.getVendorCase(client.getVen_code());
	}
%>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=20%>고객구분</td>
                    <td width=30%>&nbsp; 
                    <%if(client.getClient_st().equals("1")) 		out.println("법인");
                      	else if(client.getClient_st().equals("2"))  out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");
        				else if(client.getClient_st().equals("6")) 	out.println("경매장");%>
                    </td>
                    <td class='title' width=20%>개업년월일</td>
                    <td width=30%>&nbsp;<%= client.getOpen_year()%></td>
                </tr>
                <tr> 
                    <td class='title'> 상호</td>
                    <td>&nbsp; <%=client.getFirm_nm()%> </td>
                    <td class='title'>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>생년월일(법인번호)</td>
                    <td>&nbsp;<%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
                    <td class='title'>사업자번호</td>
                    <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                </tr>
                <tr> 
                    <td class='title'>본점소재지</td>
                    <td colspan='3'>&nbsp; 
                        <%if(!client.getHo_addr().equals("")){%>
                        ( 
                        <%}%>
                        <%=client.getHo_zip()%> 
                        <%if(!client.getHo_addr().equals("")){%>
                        )&nbsp; 
                        <%}%>
                        <%=client.getHo_addr()%></td>
                </tr>
                <tr> 
                    <td class='title'>사업장 주소</td>
                    <td colspan='3'>&nbsp; 
                    <%if(!client.getO_addr().equals("")){%>
                    ( 
                    <%}%>
                    <%=client.getO_zip()%> 
                    <%if(!client.getO_addr().equals("")){%>
                    )&nbsp; 
                    <%}%>
                    <%=client.getO_addr()%></td>
                </tr>
                <tr> 
                    <td class='title'>업태</td>
                    <td>&nbsp;<%=client.getBus_cdt()%></td>
                    <td class='title'>종목</td>
                    <td>&nbsp;<%=client.getBus_itm()%></td>
                </tr>
                <%if(client.getClient_st().equals("2")){%>
                <%}%>
                <tr> 
                    <td class='title'>자택전화번호</td>
                    <td>&nbsp;<%=client.getH_tel()%></td>
                    <td class='title'>회사전화번호</td>
                    <td>&nbsp;<%=client.getO_tel()%>&nbsp;<%=client.getM_tel()%></td>
                </tr>
                <tr> 
                    <td class='title'>휴대폰</td>
                    <td>&nbsp;<%=client.getM_tel()%></td>
                    <td class='title'>FAX</td>
                    <td>&nbsp;<%=client.getFax()%></td>
                </tr>
                <tr> 
                    <td class='title'> E-mail </td>
                    <td colspan='3'>
                        <table border="0" cellspacing="1" cellpadding="4" width=100% height='40'>
                            <tr> 
                                <td><%=client.getCon_agnt_email()%> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td class='title'> 특이사항 </td>
                    <td colspan='3'>
                        <table border="0" cellspacing="1" cellpadding="4" width=100% height='40'>
                            <tr> 
                                <td><%=Util.htmlBR(client.getEtc())%> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:window.close()"><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
	</tr>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
