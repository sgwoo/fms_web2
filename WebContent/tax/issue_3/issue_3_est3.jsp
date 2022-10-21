<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, tax.*, acar.bill_mng.*, acar.client.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	int tae_sum = 0;
	int max_table_line = 3;
	int height = 0;
	String tax_supply = "";
	String tax_value = "";
	
	//매각 스케줄
	Vector grts = ScdMngDb.getOfflsScdList(s_br, "", "N");
	int grt_size = grts.size();	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function client_select(client_id, site_id, firm_nm, car_mng_id, rent_l_cd){
		var fm = document.form1;
		fm.client_id.value = client_id;	
		fm.site_id.value = site_id;
		fm.firm_nm.value = firm_nm;
		fm.car_mng_id.value = car_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.action = "issue_3_sc3.jsp";
		fm.target = "d_content";
		fm.submit();
	}
//-->
</script>

</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="client_id" value="<%=client_id%>">
  <input type="hidden" name="site_id" value="<%=site_id%>">  
  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="mode" value="<%=mode%>">  
  <input type="hidden" name="firm_nm" value="">  
<table width=100% border=0 cellpadding=0 cellspacing=0>  
    <tr> 
      <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매각 미발행리스트</span></td>
    </tr> 
    <tr><td class=line2 colspan=2></td></tr> 
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>        
            <tr>
              <td width='5%' class='title'>연번</td>
              <td width='9%' class='title'>매각방식</td>
              <td width='10%' class='title'>매각대상</td>
              <td width='11%' class='title'>상호</td>
              <td width='9%' class='title'>대표자</td>		  
              <td width='10%' class='title'>차량번호</td>
              <td width='10%' class='title'>차명</td>
              <td width='9%' class='title'>매매대금</td>
              <td width='9%' class='title'>계약금</td>
              <td width='9%' class='title'>잔금</td>
              <td width='9%' class='title'>계약일자</td>
            </tr>
    		<%	if(grt_size > 0){
    				for (int i = 0 ; i < grt_size ; i++){
    					Hashtable grt = (Hashtable)grts.elementAt(i);%>		
            <tr>
              <td align="center"><%=i+1%></td>
              <td align="center"><%=grt.get("OFFLS_ST_NM")%></td>		  
              <td align="center"><%=grt.get("CLIENT_ST_NM")%></td>
              <td align="center"><a href="javascript:client_select('<%=grt.get("CLIENT_ID")%>','','<%=grt.get("FIRM_NM")%>','<%=grt.get("CAR_MNG_ID")%>','')"><span title='<%=grt.get("FIRM_NM")%> <%=grt.get("RELATION")%> <%=grt.get("ETC")%>'><%=AddUtil.subData(String.valueOf(grt.get("FIRM_NM")), 6)%></span></a></td>
              <td align="center"><span title='<%=grt.get("CLIENT_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("CLIENT_NM")), 5)%></span></td>		  
              <td align="center"><%=grt.get("CAR_NO")%></td>
              <td align="center"><span title='<%=grt.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("CAR_NM")), 5)%></span></td>
              <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("MM_PR")))%>원&nbsp;</td>
              <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("CONT_PR")))%>원&nbsp;</td>
              <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("JAN_PR")))%>원&nbsp;</td>
              <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("CONT_DT")))%></td>
            </tr>
    		<%		}
    			}%>
    <% 		if(grt_size == 0){%>
    		<tr>
    		  <td colspan="11" align="center">등록된 데이타가 없습니다.</td>
    		</tr>
    <% 		}%>					
        </table>
      </td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>	
  </table>
</form>
</body>
</html>
