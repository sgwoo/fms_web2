<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	
	//ARS call 현황
	Vector vt = wc_db.ArsCallStatMon(s_yy);
	int vt_size = vt.size();
	
	long total_amt1[]	 		= new long[13];
	
	double total_amt2 = 0;
	for (int i = 0 ; i < vt_size ; i++){
        Hashtable ht = (Hashtable)vt.elementAt(i);
        total_amt2 = total_amt2 + AddUtil.parseDouble(String.valueOf(ht.get("AMT")));
	}
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function Search(){
	var fm = document.form1;
	fm.action="ars_call_stat_mon_sc.jsp";
	fm.target="_self";
	fm.submit();
}
//팝업
function display_pop(call_user_id, s_mm){
	var fm = document.form1;
	document.form1.s_mm.value = s_mm;
	if(call_user_id == ''){
		fm.action="ars_call_stat_mon_list.jsp";
		
	}else{
		document.form1.call_user_id.value = call_user_id;
		fm.action="ars_call_stat_base_list.jsp";		
	}
	fm.target="_blank";
	fm.submit();
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='ars_call_stat_mon_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='s_mm' value=''>
<input type='hidden' name='call_user_id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1250>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월별 당직수당 지급현황 </span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
						<select name="s_yy">
			  			<%for(int i=2020; i<=AddUtil.getDate2(1); i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					</td>
                </tr>
            </table>
        </td>
    </tr>	 	     
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan='2' width='50' class='title'>연번</td>
                    <td rowspan='2' width='80' class='title'>사번</td>
                    <td rowspan='2' width='80' class='title'>성명</td>                    
                    <td colspan='13' class='title'>월별 당직수당 지급현황</td>
                    <td rowspan='2' width='100' class='title'>개인별점유비</td>
                </tr>
                <tr>
                	<%for (int j = 0 ; j < 12 ; j++){%>
                    <td width='80' class=title><%=j+1%>월</td>
				    <%}%>	
                    <td width='80' class='title'>합계</td>
                </tr>                
                <%	if(vt_size > 0){
		            	for (int i = 0 ; i < vt_size ; i++){
				            Hashtable ht = (Hashtable)vt.elementAt(i);
				            
				            total_amt1[0]	= total_amt1[0] + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				            
				            for(int j = 1 ; j <= 12 ; j++){
								total_amt1[j]	= total_amt1[j] + AddUtil.parseLong(String.valueOf(ht.get("AMT_"+j)));
							}
				%>
                <tr>
                    <td align=center><%=i+1%></td>
                    <td align=center><%=ht.get("ID")%></td>
                    <td align=center><%=ht.get("USER_NM")%></td>
                    <%for(int j = 1 ; j <= 12 ; j++){ %>
   				    <td align="right"><a href="javascript:display_pop('<%=ht.get("USER_ID")%>','<%=AddUtil.addZero2(j)%>')"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT_"+j)))%></a></td>
				    <%} %>
                    <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT")))%></td>
                    <td align="center"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseDouble(String.valueOf(ht.get("AMT")))/total_amt2*100),2) %>%</td>
                </tr>                   
		            <%	}%>
                <tr>
                    <td colspan="3" class='title'>합계</td>
                    <%for(int j = 1 ; j <= 12 ; j++){ %>
                    <td align="right"><a href="javascript:display_pop('','<%=AddUtil.addZero2(j)%>')"><%=AddUtil.parseDecimalLong(total_amt1[j])%></a></td>
                    <%} %>
                    <td align="right"><%=AddUtil.parseDecimal(total_amt1[0])%></td>
                    <td class='title'></td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="17" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>                     	        
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
