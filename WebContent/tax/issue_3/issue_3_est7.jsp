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
	
	//중도해지 스케줄
	Vector grts = ScdMngDb.getClsContScdListNew(s_br, "", "N");
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
	function client_select(client_id, site_id, firm_nm, rent_mng_id, rent_l_cd){
		var fm = document.form1;
		fm.client_id.value = client_id;	
		fm.site_id.value = site_id;
		fm.firm_nm.value = firm_nm;
		fm.rent_mng_id.value = rent_mng_id;	
		fm.rent_l_cd.value = rent_l_cd;	
		fm.action = "issue_3_sc7.jsp";
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
      <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>해지정산금 미발행리스트</span></td>
    </tr>
    <tr><td class=line2 colspan=2></td></tr>  
    <tr>
      <td colspan="2" class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='4%' class='title'>연번</td>
              <td width='5%' class='title'>구분</td>
              <td width='10%' class='title'>계약번호</td>
              <td width='12%' class='title'>상호</td>
              <td width="8%" class='title'>차량번호</td>
              <td width="11%" class='title'>차명</td>
              <td width="8%" class='title'>해지일자</td>
              <td width="9%" class='title'>미납대여료</td>
              <td width="9%" class='title'>해지위약금</td>
              <td width="8%" class='title'>회수외주비용</td>
              <td width='8%' class='title'>회수부대비용</td>
              <td width='8%' class='title'>기타손해배상금</td>
             </tr>
    		<%	if(grt_size > 0){
    				for (int i = 0 ; i < grt_size ; i++){
    					Hashtable grt = (Hashtable)grts.elementAt(i);%>		
            <tr>
              <td align="center"><%=i+1%></td>
              <td align="center"><%=grt.get("ST_NM")%></td>		  
              <td align="center"><a href="javascript:client_select('<%=grt.get("CLIENT_ID")%>','','<%=grt.get("FIRM_NM")%>','<%=grt.get("RENT_MNG_ID")%>','<%=grt.get("RENT_L_CD")%>')"><%=grt.get("RENT_L_CD")%></a></td>
              <td align="center"><span title='<%=grt.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("FIRM_NM")), 8)%></span></a></td>
              <td align="center"><%=grt.get("CAR_NO")%></td>
              <td align="center"><span title='<%=grt.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(grt.get("CAR_NM")), 9)%></span></td>		  
              <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(grt.get("CLS_DT")))%></td>
              <td align="right"><%=Util.parseDecimal( AddUtil.parseInt(String.valueOf( grt.get("DFEE_AMT_S"))) + AddUtil.parseInt(String.valueOf( grt.get("DFEE_AMT_V"))) )%>원&nbsp;</td>
              <td align="right"><%=Util.parseDecimal( AddUtil.parseInt(String.valueOf( grt.get("DFT_AMT_S"))) + AddUtil.parseInt(String.valueOf( grt.get("DFT_AMT_V"))) )%>원&nbsp;</td>
              <td align="right"><%=Util.parseDecimal( AddUtil.parseInt(String.valueOf( grt.get("ETC_AMT_S"))) + AddUtil.parseInt(String.valueOf( grt.get("ETC_AMT_V"))) )%>원&nbsp;</td>
              <td align="right"><%=Util.parseDecimal( AddUtil.parseInt(String.valueOf( grt.get("ETC2_AMT_S"))) + AddUtil.parseInt(String.valueOf( grt.get("ETC2_AMT_V"))) )%>원&nbsp;</td>
              <td align="right"><%=Util.parseDecimal( AddUtil.parseInt(String.valueOf( grt.get("ETC4_AMT_S"))) + AddUtil.parseInt(String.valueOf( grt.get("ETC4_AMT_V"))) )%>원&nbsp;</td>
              </tr>
    		<%		}
    			}%>
    <% 		if(grt_size == 0){%>
    		<tr>
    		  <td colspan="12" align="center">등록된 데이타가 없습니다.</td>
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
