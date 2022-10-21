<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;


	
	String vid_num		= "";
	String ba_code 		= "";
	String ba_firm 		= "";	
	String ba_user_nm 	= "";
	String ba_cau_score	= "";
	String ba_cau		= "";		

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;	
		
		if(confirm('등록하시겠습니까?')){
			fm.action = "ba_stat_score_reg_a.jsp";	
			fm.target='i_no';
			fm.submit();
		}
	}
	

	function cng_all(value){
		var fm = document.form1;
		<%	if(vid_size>1){
				for(int i=0;i < vid_size;i++){%>				
						fm.ba_score[<%=i%>].value = value;				
		<%		}
			}else{%>
						fm.ba_score.value = value;				
		<%	}%>	
	}	
	

//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>    
  <input type='hidden' name='s_dt'  	value='<%=s_dt%>'>
  <input type='hidden' name='e_dt' 	value='<%=e_dt%>'>			




<table border=0 cellspacing=0 cellpadding=0 width=1000>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 사후관리리포트 > <span class=style5>제안댓글점수 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>일괄적용</span></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>
			    	<td width="180" class='title'>점수</td>
			    	<td width="820">&nbsp;
					  <select name='all_cng_yn' class='default' onChange="javascript:cng_all(this.value)">					        
					        <option value=''>선택</option>
					        <%for(int i=1;i <= 10;i++){%>
                                                <option value='<%=i%>'><%=i%>점</option>
                                                <%}%>
                                           </select>		
				    </td>
			    </tr>		
			</table>
		</td>
	</tr>		
    <tr>
        <td class=h></td>
    </tr> 	    
    <tr><td class=line2></td></tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>
			    	<td width="30" class='title'>연번</td>
			    	<td width="150" class='title'>상호</td>
			    	<td width="60" class='title'>작성자</td>
				<td width="690" class='title'><%if(gubun3.equals("2")){%>미<%}%>계약사유</td>
			    	<td width="70" class='title'>점수</td>
			    </tr>		
			    <%for(int i=0;i < vid_size;i++){
				
					vid_num = vid[i];
															
					int s=0; 
					StringTokenizer st = new StringTokenizer(vid_num,"|");				
					while(st.hasMoreTokens()){					
						String st_next = st.nextToken();																	
						if(s==0) ba_code 	= st_next;
						if(s==1) ba_firm 	= st_next;
						if(s==2) ba_user_nm 	= st_next;
						if(s==3) ba_cau_score 	= st_next;
						if(s==4) ba_cau 	= st_next;
						s++;
					}		
					
			    %>	
			    <input type='hidden' name='ba_code' value='<%=ba_code%>'>					
			    <tr>
			    	<td align="center"><%=i+1%></td>				
			    	<td align="center"><%=ba_firm%></td>
			    	<td align="center"><%=ba_user_nm%></td>
			    	<td>&nbsp;<%=ba_cau%></td>
			    	<td align="center">
					  <select name='ba_score' class='default'>
					        <option value=''>선택</option>
					        <%for(int j=1;j <= 10;j++){%>
                                                <option value='<%=j%>' <%if(ba_cau_score.equals(String.valueOf(j))){%>selected<%}%>><%=j%>점</option>
                                                <%}%>
                                           </select>					    	
				</td>
			    </tr>
			    <%}%>
		</table>
	</td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
	    <td align='center'>
	    <%//if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
	    <%//}%>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>			
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
			    