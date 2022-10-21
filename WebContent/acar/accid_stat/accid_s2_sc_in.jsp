<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = as_db.getAccidStat2List(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int accid_size = accids.size();
	
	int su[] = new int[13];
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='accid_size' value='<%=accid_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr> 
        <td class='line' > 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < accid_size ; i++){
    			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr> 
                    <td align="center" width=10%> 
                      <%if(i==0 && accid_size>1){%>
                      전월 
                      <%}else{%>
                      <a href="javascript:parent.AccidentDisp('<%=accid.get("ACCID_DT")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%></a> 
                      <%}%>
                    </td>
                    <td align="right" width=9%> 
                      <input type="text" name="su" value="<%=accid.get("TOT_SU")%>" size="3" class=whitenum>
                      건&nbsp;&nbsp;</td>
                    <td align="center" width=9%> 
                      <%if(i==0){%>
                      - 
                      <%}else{%>
                      <input type="text" name="per" size="4" class=whitenum>
                      % 
                      <%}%>
                    </td>
                    <td align="center" width=6%><%=accid.get("SU1")%></td>
                    <td align="center" width=6%><%=accid.get("SU2")%></td>
                    <td align="center" width=6%><%=accid.get("SU3")%></td>
                    <td align="center" width=6%><%=accid.get("SU4")%></td>
                    <td align="center" width=6%><%=accid.get("SU5")%></td>
                    <td align="center" width=6%><%=accid.get("SU6")%></td>
                    <td align="center" width=6%><%=accid.get("SU7")%></td>
                    <td align="center" width=6%><%=accid.get("SU8")%></td>
                    <td align="center" width=6%><%=accid.get("SU9")%></td>
                    <td align="center" width=6%><%=accid.get("SU10")%></td>
                    <td align="center" width=6%><%=accid.get("SU11")%></td>
                    <td align="center" width=6%><%=accid.get("SU12")%></td>
                </tr>
              <%	if(i>0){
    			  		su[0]  = su[0]  + Integer.parseInt(String.valueOf(accid.get("TOT_SU")));
    			  		su[1]  = su[1]  + Integer.parseInt(String.valueOf(accid.get("SU1")));
    			  		su[2]  = su[2]  + Integer.parseInt(String.valueOf(accid.get("SU2")));
    			  		su[3]  = su[3]  + Integer.parseInt(String.valueOf(accid.get("SU3")));
    		  			su[4]  = su[4]  + Integer.parseInt(String.valueOf(accid.get("SU4")));
    			  		su[5]  = su[5]  + Integer.parseInt(String.valueOf(accid.get("SU5")));
    			  		su[6]  = su[6]  + Integer.parseInt(String.valueOf(accid.get("SU6")));
    			  		su[7]  = su[7]  + Integer.parseInt(String.valueOf(accid.get("SU7")));
    		  			su[8]  = su[8]  + Integer.parseInt(String.valueOf(accid.get("SU8")));
    			  		su[9]  = su[9]  + Integer.parseInt(String.valueOf(accid.get("SU9")));
    			  		su[10] = su[10] + Integer.parseInt(String.valueOf(accid.get("SU10")));
    			  		su[11] = su[11] + Integer.parseInt(String.valueOf(accid.get("SU11")));
    		  			su[12] = su[12] + Integer.parseInt(String.valueOf(accid.get("SU12")));
    			  	}
    		  }%>
                <tr> 
                    <td class='title'>합계</td>
                    <td class='title' style='text-align:right'><%=su[0]%>건&nbsp;</td>
                    <td class='title'>-</td>
                    <td class='title'><%=su[1]%></td>
                    <td class='title'><%=su[2]%></td>
                    <td class='title'><%=su[3]%></td>
                    <td class='title'><%=su[4]%></td>
                    <td class='title'><%=su[5]%></td>
                    <td class='title'><%=su[6]%></td>
                    <td class='title'><%=su[7]%></td>
                    <td class='title'><%=su[8]%></td>
                    <td class='title'><%=su[9]%></td>
                    <td class='title'><%=su[10]%></td>
                    <td class='title'><%=su[11]%></td>
                    <td class='title'><%=su[12]%></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<script language='javascript'>
<!--
	var fm = document.form1;
	var size = fm.accid_size.value;
	if(size>2){
		for(var i = 1 ; i < size ; i++){
			fm.per[i-1].value = Math.round(fm.su[i].value / fm.su[i-1].value * 100);
		}
	}else{
		fm.per.value = Math.round(fm.su[1].value / fm.su[0].value * 100);
	}
//-->
</script>
</form>
</body>
</html>
