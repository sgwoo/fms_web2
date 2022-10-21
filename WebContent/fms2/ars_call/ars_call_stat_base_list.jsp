<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*, acar.user_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd 	= request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String call_user_id = request.getParameter("call_user_id")==null?"":request.getParameter("call_user_id");
	
	
	//ARS call 현황
	Vector vt = wc_db.ArsCallStatBaseList(s_yy, s_mm, s_dd, call_user_id);
	int vt_size = vt.size();
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	
	UsersBean user_bean 	= new UsersBean();
	
	if(!call_user_id.equals("")){
		user_bean = umd.getUsersBean(call_user_id);
	}
	
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
<form name='form1' action='ars_call_stat_base_list.jsp' method='post' target='t_content'>

  <table border="0" cellspacing="0" cellpadding="0" width=770>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(!call_user_id.equals("")){%>[<%=user_bean.getUser_nm()%>] <%}%><%if(!s_yy.equals("")){%><%=s_yy%>년<%=s_mm%>월<%}%><%if(!s_dd.equals("")){%><%=s_dd%>일<%}%> ARS 콜현황 </span></td>
	  </tr>    
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='50' class='title'>연번</td>
                    <td width='170' class='title'>콜종료시간</td>
                    <td width='100' class='title'>고객발신번호</td>
                    <td width='250' class='title'>고객명</td>                    
                    <td width='100' class='title'>차량번호</td>
                    <td width='100' class='title'>상담구분</td>
                    <td width='100' class='title'>통화시간</td>
                </tr>                             
                <%	if(vt_size > 0){
		            	for (int i = 0 ; i < vt_size ; i++){
				            Hashtable ht = (Hashtable)vt.elementAt(i);
				            
				            int v_time = AddUtil.parseInt(String.valueOf(ht.get("BILL_DURATION")));
				            int v_m = 0;
				            int v_s = 0;
				            
			    	        //오버 초 처리
			        	    if(v_time > 60){
			            		int add_m = v_time/60;
				            	v_m = v_m + add_m;
				            	v_s = v_time - (add_m*60);
				            }else{
				            	v_s = v_time;
				            }
				%>
                <tr>
                    <td align=center><%=i+1%></td>
                    <td align=center><%=ht.get("HANGUP_TIME")%></td>
                    <td align=center><%=ht.get("CID")%></td>
                    <td align="center"><%=ht.get("FIRM_NM")%></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>
                    <td align=center><%=ht.get("INFO_TYPE_NM")%></td>
                    <td align="center"><%=AddUtil.addZero2(v_m)%>분<%=AddUtil.addZero2(v_s)%>초</td>
                </tr>                   
		        <%		}%>               
		        <%	}%>
            </table>
	    </td>
    </tr>                       	        
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
