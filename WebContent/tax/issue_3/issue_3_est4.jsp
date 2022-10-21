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
	String tax_yn = "N";
	
	//기타(차량수리비) 스케줄
	Vector grts = ScdMngDb.getAccidServScdList(s_br, "", tax_yn);
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
	function client_select(client_id, site_id, firm_nm, rent_mng_id, rent_l_cd, tax_est_dt){
		var fm = document.form1;
		fm.client_id.value = client_id;	
		fm.site_id.value = site_id;
		fm.firm_nm.value = firm_nm;
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.tax_est_dt.value = tax_est_dt;
		fm.action = "issue_3_sc4.jsp";
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
  <input type="hidden" name="tax_est_dt" value="">  
  <table width=100% border=0 cellpadding=0 cellspacing=0> 
    <tr> 
      <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타 미발행리스트</span></td>
    </tr> 
    <tr><td class=line2 colspan=2></td></tr> 
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>      	      	
            <tr>
              <td width='4%' class='title'>연번</td>
              <td width='6%' class='title'>구분</td>
              <td width='10%' class='title'>계약번호</td>
              <td width='11%' class='title'>상호</td>
              <td width='10%' class='title'>차량번호</td>
              <td width='10%' class='title'>차명</td>
              <td width='9%' class='title'>정비업체</td>
              <td width='9%' class='title'>정비비</td>
              <td width='7%' class='title'>면책금</td>
              <td width='8%' class='title'>사고일자</td>
              <td width='8%' class='title'>청구일자</td>
              <td width='8%' class='title'>입금일자</td>			  
            </tr>
    		<%	if(grt_size > 0){
    				for (int i = 0 ; i < grt_size ; i++){
    					Hashtable grt = (Hashtable)grts.elementAt(i);%>		
            <tr>
              <td align="center"><%=i+1%></td>
              <td align="center"><%=grt.get("ST_NM")%></td>		  
              <td align="center"><a href="javascript:client_select('<%=grt.get("CLIENT_ID")%>','','<%=grt.get("FIRM_NM")%>','<%=grt.get("RENT_MNG_ID")%>','<%=grt.get("RENT_L_CD")%>','<%=grt.get("CUST_REQ_DT")%>')"><%=grt.get("RENT_L_CD")%></a></td>
              <td align="center"><span title='<%=grt.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("FIRM_NM")), 6)%></span></a></td>
              <td align="center"><%=grt.get("CAR_NO")%></td>
              <td align="center"><span title='<%=grt.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("CAR_NM")), 5)%></span></td>
              <td align="center"><span title='<%=grt.get("OFF_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("OFF_NM")), 4)%></span></td>
              <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("TOT_AMT")))%>원&nbsp;</td>
              <td align="right"><%=Util.parseDecimal(String.valueOf(grt.get("CUST_AMT")))%>원&nbsp;</td>
              <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("ACCID_DT")))%></td>
              <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("CUST_REQ_DT")))%></td>
              <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("CUST_PAY_DT")))%></td>			  
            </tr>
    		<%		}
    			}%>
    <% 		if(grt_size == 0){%>
    		<tr>
    		  <td colspan="12" align="center">등록된 데이타가 없습니다.</td>
    		</tr>
<% 		}%>					
        </table></td>
    </tr>
    <tr>
      <td colspan="2">* 타시스템발행일 경우에는 나오지 않습니다.</td>
    </tr>	
  </table>
</form>
</body>
</html>
