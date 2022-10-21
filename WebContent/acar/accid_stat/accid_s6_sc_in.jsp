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
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = as_db.getAccidStat6List(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int accid_size = accids.size();
	
	int tot_su = 0;
	long tot_amt = 0;	
%>

<form name='form1' action='' method='post' target='d_content'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr id='tr_title' > 
        <td class='line' > 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <% 		for (int i = 0 ; i < accid_size ; i++){
    			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr> 
                    <td width="8%" align="center"><%=i+1%></td>
                    <td width="26%">&nbsp;<span title='<%=accid.get("OFF_NM")%>'><a href="javascript:parent.view_detail('<%=accid.get("OFF_ID")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(accid.get("OFF_NM")), 13)%></a></span></td>
                    <td width="11%" align="center"><%=AddUtil.ChangeEnp(String.valueOf(accid.get("ENT_NO")))%></td>
                    <td width="11%" align="center"><%=accid.get("OFF_TEL")%></td>
                    <td width="11%" align="center"><%=accid.get("OFF_FAX")%></td>
                    <td width="11%" align="center"><%=accid.get("TOT_SU")%>건</td>
                    <td width="11%" align="right"><%=Util.parseDecimal(String.valueOf(accid.get("TOT_AMT")))%></td>
                    <td width="11%" align="center">&nbsp;</td>
                </tr>
              <%	tot_su = tot_su  + Integer.parseInt(String.valueOf(accid.get("TOT_SU")));
    				tot_amt = tot_amt + Long.parseLong(String.valueOf(accid.get("TOT_AMT")));
    		  }%>
                <tr> 
                    <td class=title align="center">&nbsp;</td>
                    <td class=title align="center">합계</td>
                    <td class=title align="center">&nbsp;</td>
                    <td class=title align="center">&nbsp;</td>
                    <td class=title align="center">&nbsp;</td>
                    <td class=title align="center"><%=tot_su%>건</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(tot_amt)%></td>
                    <td class=title align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<script language='javascript'>
<!--
/*	var fm 		= document.form1;
	var p_fm	= parent.form1;
	var cnt 	= fm.fee_size.value;
	
	var i_amt = 0;
	
	if(cnt > 1){
		for(var i = 0 ; i < cnt ; i++){
			i_amt   += toInt(parseDigit(fm.amt[i].value));
		}
	}else if(cnt == 1){
		i_amt   += toInt(parseDigit(fm.amt.value));	
	}		*/
-->
</script>
</form>
</body>
</html>
