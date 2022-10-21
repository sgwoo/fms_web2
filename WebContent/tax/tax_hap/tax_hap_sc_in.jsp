<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	

	Vector vts = new Vector();
	
	if(AddUtil.parseInt(gubun1) >=2017){
		vts = ScdMngDb.getTaxHapList_2018(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	}else{
		vts = ScdMngDb.getTaxHapList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	}
	
	int vt_size = vts.size();
	
	int  client_cnt[]  	= new int[3];
	int  tax_cnt[]     	= new int[3];
	long tax_supply[] 	= new long[3];
	long tax_value[]  	= new long[3];
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
  	<tr><td class=line2 colspan=2></td></tr>
    <tr>
	    <td class='line' width='100%'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr> 
              <td width='10%' class='title'>연번</td>
              <td width='20%' class='title'>사업자번호</td>
              <td width='30%' class='title'>상호</td>
              <td width='10%' class='title'>매수</td>
              <td width='15%' class='title'>공급가</td>
              <td width='15%' class='title'>세액</td>
            </tr>
<%	if(vt_size > 0){%>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <%  if(String.valueOf(ht.get("ENP_NO")).length() == 10){
                client_cnt[1] += 1;
                tax_cnt[1]    += AddUtil.parseInt(String.valueOf(ht.get("CNT")));
                tax_supply[1] += AddUtil.parseLong(String.valueOf(ht.get("TAX_SUPPLY")));
                tax_value[1]  += AddUtil.parseLong(String.valueOf(ht.get("TAX_VALUE")));
              }else{
                client_cnt[2] += 1;
                tax_cnt[2]    += AddUtil.parseInt(String.valueOf(ht.get("CNT")));
                tax_supply[2] += AddUtil.parseLong(String.valueOf(ht.get("TAX_SUPPLY")));
                tax_value[2]  += AddUtil.parseLong(String.valueOf(ht.get("TAX_VALUE")));
              }
            %>				      
            <tr> 
              <td width='10%' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
              <td width='20%' align='center'><a href="javascript:parent.view_tax_popup('<%=ht.get("ENP_NO")%>','<%=i+1%>')" onMouseOver="window.status=''; return true"><%=AddUtil.ChangeEnp(AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO"))))%></a></td>
              <td width='30%' align='center'><span title='<%=ht.get("FIRM_NM")%>(<%=ht.get("CLIENT_ID")%>)'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 18)%></span></td>            
              <td width='10%' align='center'><%=ht.get("CNT")%>&nbsp;<%//=ht.get("MIN_TAX")%></td>
              <td width='15%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_SUPPLY")))%>원&nbsp;&nbsp;&nbsp;&nbsp;</td>
              <td width='15%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_VALUE")))%>원&nbsp;&nbsp;&nbsp;&nbsp;</td>
            </tr>
          <%}%>
<%	}else{%>                     
          <tr> 
            <td colspan='6' align='center'>등록된 데이타가 없습니다</td>
          </tr>
<% 	}%>
        </table>
      </td>
    </tr>
  </table>
</form>
<script language='javascript'>
<!--
  var fm = parent.document.form1;
  <% for(int i =1; i<3; i++){%>
  fm.client_cnt[<%=i%>].value = <%=client_cnt[i]%>;
  fm.tax_cnt[<%=i%>].value    = <%=tax_cnt[i]%>;
  fm.tax_supply[<%=i%>].value = parseDecimal(<%=tax_supply[i]%>);
  fm.tax_value[<%=i%>].value  = parseDecimal(<%=tax_value[i]%>);
  <% }%>
  fm.client_cnt[0].value  = toInt(fm.client_cnt[1].value)+toInt(fm.client_cnt[2].value);
  fm.tax_cnt[0].value     = toInt(fm.tax_cnt[1].value)+toInt(fm.tax_cnt[2].value);
  fm.tax_supply[0].value  = parseDecimal(toInt(parseDigit(fm.tax_supply[1].value)) + toInt(parseDigit(fm.tax_supply[2].value)));
  fm.tax_value[0].value   = parseDecimal(toInt(parseDigit(fm.tax_value[1].value)) + toInt(parseDigit(fm.tax_value[2].value)));
//-->
</script>
</body>
</html>
