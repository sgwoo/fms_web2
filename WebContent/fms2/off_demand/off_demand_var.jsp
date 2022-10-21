<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_demand.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String var_id = request.getParameter("var_id")==null?"":request.getParameter("var_id");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	Vector vt3 = dm_db.getOffDemandVarStat(var_id, "", "");		
	int vt3_size = vt3.size();	
	
	if(vt3_size == 0){
		out.println(var_id);
		out.println(ref_dt1);
		out.println(ref_dt2);
	}	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function var_update(idx){
		var fm = document.form1;	
		if(!confirm('수정하시겠습니까?'))	return;
		fm.target='i_no';
		fm.submit();		
	}			
	function indexReload(){
		opener.location.reload();
	}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="off_demand_var_a.jsp" name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width="600">
  <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업현황 변수관리 </span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>                    
            <table border="0" cellspacing="1" cellpadding="0" width="600">
                <tr> 
                    <td width="150" class=title>기준일자</td>
                    <td width="150" class=title>변수코드</td>
                    <td width="150" class=title>변수명</td>
                    <td width="150" class=title>변수값</td>                                        
                </tr>
          		<%
          			String var_nm = "";
          			for(int i = 0 ; i < vt3_size ; i++){
      					Hashtable ht = (Hashtable)vt3.elementAt(i);
      					var_nm = ht.get("VAR_NM")+"";
				%>
                <tr> 
                    <input type="hidden" name="mode" value="u">
                    <input type="hidden" name="save_dt" value="<%=ht.get("SAVE_DT")%>">
                    <input type="hidden" name="var_id" value="<%=ht.get("VAR_ID")%>">
                    <input type="hidden" name="var_nm" value="<%=ht.get("VAR_NM")%>">
                    <td align=center><%=ht.get("SAVE_DT")%></td>
                    <td align=center><%=ht.get("VAR_ID")%></td>
                    <td align=center><%=ht.get("VAR_NM")%></td>
                    <td align=center><input type="text" name="var_cd" size="12" class="num" value="<%=ht.get("VAR_CD")%>"> </td>                    
                </tr>
            	<%}%>
            	<tr>                     
            	    <input type="hidden" name="mode" value="i">
                    <input type="hidden" name="var_id" value="<%=var_id%>">
                    <input type="hidden" name="var_nm" value="<%=var_nm%>">
                    <td align=center><input type="text" name="save_dt" size="12" class="text" value=""></td>
                    <td align=center><%=var_id%></td>
                    <td align=center><%=var_nm%></td>
                    <td align=center><input type="text" name="var_cd" size="12" class="num" value=""></td>                    
                </tr>
            </table>
        </td>
    </tr>
    <tr>    	
        <td align="right">
        	<a href="javascript:var_update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>
        </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>