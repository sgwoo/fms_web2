<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.client.*, acar.util.*"%>
<%@ page import="acar.offls_cmplt.*"%>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function select_client()
	{
		var fm = document.form1;
		fm.h_c_id.value 		= "";
		fm.h_gbn.value 			= "";
		fm.t_cl_gbn.value 		= "";
		fm.t_client_nm.value	= "";
		fm.t_firm_nm.value 		= "";
		fm.t_ssn.value 			= "";
		fm.t_enp_no.value 		= "";
		fm.t_o_tel.value 		= "";
		fm.t_homepage.value	 	= "";
		fm.t_fax.value 			= "";
		fm.t_o_zip.value 		= "";
		fm.t_o_addr.value 		= "";
		fm.t_bus_cdt.value		= "";
		fm.t_bus_itm.value		= "";
		fm.t_open_year.value	= "";
		fm.t_firm_price.value 	= "";  
		fm.t_firm_price_y.value = ""; 
//		fm.t_firm_price_b.value = ""; 
		window.open("./client_s_p.jsp", "CLIENT", "left=100, top=100, width=620, height=450");
	}	
-->
</script>
<link rel=stylesheet type="text/css" href="file:///C|/inetpub/wwwroot/include/table.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	CmpltBean cmplt = olcD.getCmpltBean(car_mng_id);

	ClientBean client = al_db.getClient(cmplt.getClient_id());
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name="h_c_id" value='<%=cmplt.getClient_id()%>'>
<input type='hidden' name="h_gbn" value=''>

  <table border=0 cellspacing=0 cellpadding=0 width='800'>
    <tr> 
      <td height="21" align='left'><< 매각처정보 >> </td>
    </tr>
    <tr> 
      <td class='line'> <table border="0" cellspacing="1" cellpadding='0' width=800>
          <tr> 
            <td width='110' class='title'> <a href='javascript:select_client()' title="클릭하세요"><font color="#FFFF00">고객구분</font></a></td>
            <td width='150' align='left'>&nbsp; <input type='text' name="t_cl_gbn" 
                			<% if(client.getClient_st().equals("1")){%>value='법인'
							<% }else if(client.getClient_st().equals("2")){%>value='개인'
							<% }else if(client.getClient_st().equals("3")){%>value='개인사업자(일반과세)'
							<% }else if(client.getClient_st().equals("4")){%>value='개인사업자(간이과세)'
							<% }else if(client.getClient_st().equals("5")){%>value='개인사업자(면세사업자)'
							<% }%>size='20' class='whitetext' readonly> </td>
            <td width='110' class='title'>상호</td>
            <td width='155' align='left'>&nbsp; <input type='text' name="t_firm_nm" value='<%=client.getFirm_nm()%>' size='20' class='whitetext' readonly title='<%=client.getFirm_nm()%>'> 
            </td>
            <td width='110' class='title'>고객명</td>
            <td align='left'>&nbsp; <input type='text' name="t_client_nm" value='<%=client.getClient_nm()%>' size='15' class='whitetext' readonly>
              &nbsp; </td>
          </tr>
          <tr> 
            <td class='title' width="110">사업자등록번호</td>
            <td align='left' width="150">&nbsp; <input type='text' name="t_enp_no" value='<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>' size="15" class='whitetext' readonly> 
            </td>
            <td class='title' width="110">주민등록번호</td>
            <td align='left' width="155">&nbsp; <input type='text' name="t_ssn" value='<%=client.getSsn1()%>-<%=client.getSsn2()%>' size='15' class='whitetext' readonly> 
            </td>
            <td width='110' class='title'>Homepage</td>
            <td align='left'>&nbsp; <%if(!client.getHomepage().equals("") && client.getHomepage().length() > 7){%> <a href="<%=client.getHomepage()%>" target="_bank"> 
              <input type='text' name="t_homepage" value='<%=client.getHomepage()%>' size='20' class='whitetext' readonly>
              </a> <%}else{%> <input type='text' name="t_homepage" value='<%=client.getHomepage()%>' size='20' class='whitetext' readonly> 
              <%}%> </td>
          </tr>
          <tr> 
            <td class='title' width="110">사무실전화</td>
            <td align='left' width="150">&nbsp; <input type='text' name="t_o_tel" value='<%= client.getO_tel()%>' size='15' class='whitetext' readonly> 
            </td>
            <td class='title' width="110">FAX 번호</td>
            <td align='left'>&nbsp; <input type='text' name="t_fax" value='<%= client.getFax()%>' size='15' class='whitetext' readonly> 
              &nbsp; </td>
            <td class='title' width="110">개업년월일</td>
            <td class='left'>&nbsp; <input type='text' name="t_open_year" value='<%= client.getOpen_year()%>' size='20' class='whitetext' readonly> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="110">자본금/기준일</td>
            <td align='left'>&nbsp; <input type='text' name="t_firm_price" value='<%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"백만원/"+client.getFirm_day());%>' size='22' class='whitetext' readonly> 
            </td>
            <td class='title' width="110">연매출/기준일</td>
            <td align='left' colspan="3">&nbsp; <input type='text' name="t_firm_price_y" value='<%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"백만원/"+client.getFirm_day_y());%>' size='22' class='whitetext' readonly> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="110">업태</td>
            <td align='left'>&nbsp; <input type='text' name="t_bus_cdt" size='22' class='whitetext' readonly value="<%= client.getBus_cdt()%>"> 
            </td>
            <td class='title' width="110">종목</td>
            <td align='left' colspan="3">&nbsp; <input type='text' name="t_bus_itm" size='50' class='whitetext' readonly value="<%= client.getBus_itm()%>"> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="110">사업장주소</td>
            <td colspan="5">&nbsp; <input type='text' name="t_o_zip" value='<%=client.getO_zip()%>' size="7" class='whitetext' readonly> 
              <input type='text' name="t_o_addr" value='<%=client.getO_addr()%>' size="59" class='whitetext' readonly> 
            </td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
</body>
</html>
