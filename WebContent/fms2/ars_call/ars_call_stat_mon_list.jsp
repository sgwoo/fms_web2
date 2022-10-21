<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(1):request.getParameter("s_mm");
	
	
	//ARS call 현황
	Vector vt = wc_db.ArsCallStatMonList(s_yy, s_mm);
	int vt_size = vt.size();
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//팝업
function display_pop(call_user_id){
	var fm = document.form1;
	document.form1.call_user_id.value = call_user_id;
	fm.action="ars_call_stat_base_list.jsp";		
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
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='call_user_id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=900>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=s_yy%>년<%=s_mm%>월 사원별 당직수당 지급현황 </span></td>
	  </tr>    
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan='2' width='15%' class='title'>연번</td>
                    <td rowspan='2' width='15%' class='title'>사번</td>
                    <td rowspan='2' width='20%' class='title'>성명</td>                    
                    <td colspan='2' class='title'>통화량</td>
                    <td rowspan='2' width='20%' class='title'>당직수당</td>
                </tr>
                <tr>
                    <td width='15%' class='title'>건수</td>
                    <td width='15%' class='title'>시간</td>
                </tr>                
                <%	long call_amt = 0; 
                	if(vt_size > 0){
		            	for (int i = 0 ; i < vt_size ; i++){
				            Hashtable ht = (Hashtable)vt.elementAt(i);
				            int v_h = AddUtil.parseInt(String.valueOf(ht.get("TH")));
				            int v_m = AddUtil.parseInt(String.valueOf(ht.get("TM")));
				            int v_s = AddUtil.parseInt(String.valueOf(ht.get("TS")));
			    	        //오버 초 처리
			        	    if(v_s > 60){
			            		int add_m = v_s/60;
				            	v_m = v_m + add_m;
				            	v_s = v_s - (add_m*60);
				            }
				            //오버 분 처리
			    	        if(v_m > 60){
			        	    	int add_h = v_m/60;
			            		v_h = v_h + add_h;
				            	v_m = v_m - (add_h*60);
				            }
			            	
				            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CALL_COUNT")));
				            total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("CALL_AMT")));
				            
				            
				%>
                <tr>
                    <td align=center><%=i+1%></td>
                    <td align=center><%=ht.get("ID")%></td>
                    <td align=center><a href="javascript:display_pop('<%=ht.get("USER_ID")%>')"><%=ht.get("USER_NM")%></a></td>
                    <td align="right"><%=ht.get("CALL_COUNT")%></td>
                    <td align="right"><%=v_h%>시<%=v_m%>분<%=v_s%>초</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CALL_AMT"))) %></td>
                </tr>                   
		            <%	}%>
                <tr>
                    <td colspan="3" class='title'>합계(월 단위)</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td class='title'></td>
                    <td align="right"><%=AddUtil.parseDecimal(total_amt2)%></td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="6" align="center">등록된 데이타가 없습니다.</td>
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
