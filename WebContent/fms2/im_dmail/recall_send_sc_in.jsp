<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.im_email.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String sort_fuel 	= request.getParameter("sort_fuel")	==null?"":request.getParameter("sort_fuel");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String gubun6 		= request.getParameter("gubun6")	==null?"":request.getParameter("gubun6");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	
	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	ImEmailDatabase ie_db = ImEmailDatabase.getInstance();
	Vector vt = ie_db.getListForRecallMail(gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, sort, sort_fuel);
	int vt_size = vt.size();
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
//모두 체크
function check_all(){
	if($("input:checkbox[id='all_chk']").is(":checked")==true){		$("input[name='ch_cd']").prop("checked",true);		}
	else{															$("input[name='ch_cd']").prop("checked",false);		}
}
</script>
</head>
<body>
<form name='form1' method='post'>
	
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
  		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' value='<%=vt_size%>' size='3' class=whitenum> 건</span>
  		</td>
	</tr>
	<tr><td class=line2 colspan="2"></td></tr>		
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td width='5%' class='title'>연번</td>
					<td width='5%' class='title'>
						<input type='checkbox' id='all_chk' onclick='javascript:check_all();'>
					</td>			    
					<td width='17%' class='title'>상호</td>		  
					<td width='8%' class='title'>차량번호</td>
					<td width='12%' class='title'>차대번호</td>
					<td width='14%' class='title'>차명</td>		
					<td width="16%" class='title'>차종</td>		
					<td width="5%" class='title'>배기량</td>				  				
					<td width="5%" class='title'>연료</td>
					<td width="8%" class='title'>차량등록일</td>  
				</tr>
<%if(vt_size > 0){
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>	
				<tr> 
					<td align="center"><%=i+1%></td>
					<td align="center">
						<input type='checkbox' name='ch_cd' id="ch_<%=i+1%>" value='<%=ht.get("CLIENT_ID")%>'>
					</td>			    
					<td align="center"><%=ht.get("FIRM_NM")%></td>		  
					<td align="center"><%=ht.get("CAR_NO")%></td>
					<td align="center"><%=ht.get("CAR_NUM")%></td>
					<td align="center"><%=ht.get("CAR_NM")%></td>		
					<td align="center"><%=ht.get("CAR_NAME")%></td>		
					<td align="center">&nbsp;<%=ht.get("DPM")%></td>				  				
					<td align="center">&nbsp;<%=ht.get("DIESEL_YN")%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_REG_DT")))%></td>  
				</tr>
<%		}%>
<%	}else{	%>
				<tr> 
					<td colspan="10" align="center">검색된 데이터가 없습니다.</td>  
				</tr> 
<%	}%>
			</table>
		</td>
	</tr>
	</table>
	<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
  	<input type='hidden' name='br_id' 		value='<%=br_id%>'>
  	<input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  	<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  	<input type='hidden' name='sort'		value='<%=sort%>'>
  	<input type='hidden' name='sort_fuel'	value='<%=sort_fuel%>'>
  	<input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  	<input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  	<input type='hidden' name='gubun3' 		value='<%=gubun3%>'>
  	<input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  	<input type='hidden' name='st_dt' 		value='<%=st_dt%>'>  
  	<input type='hidden' name='end_dt' 		value='<%=end_dt%>'>  
  	<input type='hidden' name='sh_height'	value='<%=sh_height%>'>
  	<input type='hidden' name='seq' 		value=''>  	
  	<input type='hidden' name='param' 		value=''>
  	<input type='hidden' name='cnt' 		value=''>
  	<input type='hidden' name='list_size' id="list_size" value='<%=vt_size%>'> 
</form>	

