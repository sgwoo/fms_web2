<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function modify()
	{
		if(confirm('수정하시겠습니까?'))
		{
			var fm = document.form1;			
			fm.target='i_no';
			fm.submit();
		}
	}

	function search_zip(str)
	{
		window.open("/acar/common/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}	
	
	function set_o_addr()
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.t_zip[1].value = fm.t_zip[0].value;
			fm.t_addr[1].value = fm.t_addr[0].value;
		}
		else
		{
			fm.t_zip[1].value = '';
			fm.t_addr[1].value = '';
		}
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
	//네오엠 조회하기
	function search(idx){
		var fm = document.form1;	
		window.open("../con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, scrollbars=yes");		
	}		
//-->
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
	
	ClientBean client = al_db.getClient(client_id);
%>
<body>
<form name='form1' method='post' action='/acar/mng_client2/client_u_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>고객 수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td align='right'> 
			<a href="javascript:modify()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border="0"></a>
			&nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_list.gif align=absmiddle border="0"></a>
		</td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>		 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='11%'>고객구분</td>
                    <td width="39%">&nbsp;
                        <%if(client.getClient_st().equals("1")) 		out.println("법인");
                      	else if(client.getClient_st().equals("2"))  out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");
        				else if(client.getClient_st().equals("6")) 	out.println("경매장");%>
                    </td>
                    <td width="11%" class='title'>개업년월일</td>
                    <td width="39%">&nbsp;<%= client.getOpen_year()%></td>
                </tr>
                <tr>
                    <td class='title'>상호</td>
                    <td>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class='title'>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr>
                    <td class='title'>주민(법인)번호</td>
                    <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
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
                <tr>
                    <td width="100" class='title'>직장명</td>
                    <td colspan="3">&nbsp;
                      <input type='text' size='30' name='com_nm' value='<%=client.getCom_nm()%>' maxlength='20' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>근무부서</td>
                    <td width="300">&nbsp;
                      <input type='text' size='30' name='dept' value='<%=client.getDept()%>' maxlength='15' class='text'></td>
                    <td class='title'>직위</td>
                    <td width="307">&nbsp;
                      <input type='text' size='30' name='title' value='<%=client.getTitle()%>' maxlength='10' class='text'></td>
                </tr>
		        <%}else{%>	
        			<input type='hidden' name='com_nm' value='<%=client.getCom_nm()%>'>
        			<input type='hidden' name='dept' value='<%=client.getDept()%>'>
        			<input type='hidden' name='title' value='<%=client.getTitle()%>'>		  	  
		        <%}%>		  		  		  
                <tr>
                    <td class='title'>자택전화번호</td>
                    <td>&nbsp;
                      <input type='text' size='30' name='h_tel' value='<%=client.getH_tel()%>' maxlength='15' class='text'></td>
                    <td class='title'>회사전화번호</td>
                    <td>&nbsp;
                      <input type='text' size='30' name='o_tel' value='<%=client.getO_tel()%>' maxlength='15' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>휴대폰</td>
                    <td>&nbsp;
                      <input type='text' size='30' name='m_tel' value='<%=client.getM_tel()%>' maxlength='15' class='text'></td>
                    <td class='title'>FAX</td>
                    <td>&nbsp;
                      <input type='text' size='30' name='fax' value='<%=client.getFax()%>' maxlength='15' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>Homepage</td>
                    <td colspan="3">&nbsp;
                      <input type='text' size='50' name='homepage' value='<%=client.getHomepage()%>' maxlength='70' class='text'></td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>담당자</td>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 이름:
                        <input type='text' size='15' name='con_agnt_nm' value='<%=client.getCon_agnt_nm()%>' maxlength='20' class='text'>
                        &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 사무실:
                        <input type='text' size='15' name='con_agnt_o_tel' value='<%=client.getCon_agnt_o_tel()%>' maxlength='15' class='text'>
                        &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 이동전화:
                        <input type='text' size='15' name='con_agnt_m_tel' value='<%=client.getCon_agnt_m_tel()%>' maxlength='15' class='text'>
                        &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> FAX:
                        <input type='text' size='15' name='con_agnt_fax' value='<%=client.getCon_agnt_fax()%>' maxlength='15' class='text'></td>
                </tr>
                <tr>
                    <td colspan='3'>&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> EMAIL:
                        <input type='text' size='20' name='con_agnt_email' value='<%=client.getCon_agnt_email()%>' maxlength='30' class='text' style='IME-MODE: inactive'>
                        &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 근무부서:
                        <input type='text' size='20' name='con_agnt_dept' value='<%=client.getCon_agnt_dept()%>' maxlength='15' class='text'>
                        &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 직위:
                        <input type='text' size='20' name='con_agnt_title' value='<%=client.getCon_agnt_title()%>' maxlength='10' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>이메일수신거부</td>
                    <td colspan="3">&nbsp;
                      <input name="etax_not_cau" type="text" value="<%=client.getEtax_not_cau()%>" size="90" class='text'></td>
                </tr>
                <tr>
                    <td class='title'>발행구분</td>
                    <td>&nbsp;
                      <select name='print_st'>
                        <option value='1' <%if(client.getPrint_st().equals("1")) out.println("selected");%>>계약건별</option>
                        <option value='2' <%if(client.getPrint_st().equals("2")) out.println("selected");%>>거래처통합</option>
                        <option value='3' <%if(client.getPrint_st().equals("3")) out.println("selected");%>>지점통합</option>
                        <option value='4' <%if(client.getPrint_st().equals("4")) out.println("selected");%>>현장통합</option>
                      </select>					
                    </td>
                    <td align="center" class='title'>차량사용용도</td>
                    <td>&nbsp;
                    <input type='text' size='30' name='car_use' value='<%=client.getCar_use()%>' maxlength='10' class='text'></td>
                </tr>
                <tr>
                    <td class='title'>자본금</td>
                    <td>&nbsp;
                      <input type='text' name='t_firm_price' size='10' class='num' maxlength='20' onBlur='javascript:this.value=parseDecimal2(this.value);' value="<%=AddUtil.parseDecimal(client.getFirm_price())%>">백만원
        			  <input type='text' name='t_firm_day' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="<%=client.getFirm_day()%>"></td>
                    <td class='title'>연매출</td>
                    <td>&nbsp;
                    <input type='text' name='t_firm_price_y' size='10' class='num' maxlength='40' onBlur='javascript:this.value=parseDecimal2(this.value);' value="<%=AddUtil.parseDecimal(client.getFirm_price_y())%>">백만원
			        <input type='text' name='t_firm_day_y' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value="<%=client.getFirm_day_y()%>"></td>
                </tr>
                <tr>
                    <td class='title'>네오엠</td>
                    <td colspan='3'>&nbsp;
        			  <input type='text' name='ven_name' size='30' value='<%=client.getFirm_nm()%>' class='text' style='IME-MODE: active'>
        			  &nbsp;&nbsp;<a href="javascript:search('')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border="0"></a> 	
        			  &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <input type='text' name='ven_code' size='10' value='<%=client.getVen_code()%>' class='text'>		
        			</td>
                </tr>		  		  
                <tr>
                    <td class='title'>특이사항</td>
                    <td colspan='3'>&nbsp;
        			<textarea name='etc' rows='3' cols='120' maxlenght='500'><%=client.getEtc()%></textarea></td>
                </tr>
            </table>
        </td>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>

</body>
</html>
