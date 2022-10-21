<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
		
	String s_ym 	= request.getParameter("s_ym")==null?"":request.getParameter("s_ym");
	String sh_height= request.getParameter("sh_height")==null?"":request.getParameter("sh_height");
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	
		

	//1년치 예약분 가져오기
	Vector vt = p_db.getPropResList(s_ym);
	int vt_size = vt.size();
	

	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_ym="+s_ym+
				   	"&sh_height="+sh_height+"";
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//참석예약등록	
	function Save(){
		var fm = document.form1;
					
		if(!confirm('등록하시겠습니까?'))
			return;		
			
		fm.cmd.value = "i";
		fm.target="i_no";
		fm.action = "./prop_res_a.jsp";
		fm.submit();	
	}
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLp_db="javascript:self.focus()">

<form name="form1" method="post">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_ym'  	value='<%=s_ym%>'>
  <input type='hidden' name="s_width" 	value="<%=s_width%>">   
  <input type='hidden' name="s_height" 	value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   
  <input type='hidden' name="cmd" 	value="">   
  
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > <span class=style5>제안회의참석예약 등록</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>	
	<tr>	  
	  	<td>&nbsp;</td>    
	</tr>
	<tr>
		<td class=line2></td>
	</tr>	
     	<tr> 
      		<td class=line>
	    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
          			<tr> 
          				<td width='100' class='title'>년월</td>
					<td>&nbsp;
						<select name='prop_ym'>
	  					<%for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(AddUtil.parseInt(String.valueOf(ht.get("R_PROP_DT"))) >= AddUtil.getDate2(4)){%>
						<option value='<%=ht.get("PROP_YM")%>'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROP_YM")))%> : <%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_PROP_DT")))%></option>
						<%	}%>	
						<%}%>	
						</select>
					</td>
				</tr>					
        		</table>
      		</td>   
    	</tr>	
	<tr>	  
	   <td align='right'><a href="javascript:Save()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  aligh="absmiddle" border="0"></a></td>    
	</tr>
  </table>
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0"  noresize></iframe> 
</body>
</html>