<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.asset.*"%>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		fm.work_st.value = work_st;
	
//		fm.target = 'i_no';
		
//		fm.action = 'asset_reg_a.jsp';
//		fm.submit();
		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cnt = request.getParameter("cnt")==null?"":request.getParameter("cnt");
	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int year =AddUtil.getDate2(1);
	
	year = 2021; //자산은 해당년도 이월이 끝날때까지는 당해년도만 나와야 함. 이월이 안된상태에서 등록/매각/변경을 할 수 없음. -중요!!!!!
		
	//자산 -  렌트 :2008년~2015년: 6년상각
    //렌트: 2016년부터 6.5년 상각
    //리스: 2015년부터 6.5년 상각
    

%>
<form name='form1'  method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=3>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 자산관리 > <span class=style5>자산관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>  
	<tr>
	    <td class=line2></td>
	</tr>
	
    <tr>
	    <td class='line'>
    	  <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		<tr>
    		  <td width='22%' class='title'>자산등록 기준</td>
    		  <td>
                  &nbsp;<select name="s_year">
                    <%for(int i=year; i<=year; i++){%>
                    <option value="<%=i%>" <%if(s_year == i){%>selected<%}%>><%=i%>년</option>
                    <%}%>
                  </select>
             </td>
    		</tr>
    	  </table>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  
  <% if (cnt.equals("2")) { %>  	    
  <tr>
	<td> <!--<a href="javascript:save('asset_ydep_reg')">5년자산에 반영 </a> -->&nbsp;5년자산에 반영 </td>
  </tr>
  
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td>&nbsp;년이월처리전 반드시 당기현재분 자산데이타 백업진행  (오렌지 또는 sqlgate에서 아래쿼리 실행) <br>	  
		select count(*) from fyassetdep5_bak; <br>
		select count(*) from fassetdep5_bak; <br>
		select count(*) from fyassetdep5_green_bak; <br>
		select count(*) from fassetdep5_green_bak; <br>
		select count(*) from asset_bak; <br>
		select count(*) from fyassetdep5; <br>
		select count(*) from fassetdep5; <br>
		select count(*) from fyassetdep5_green; <br>
		select count(*) from fassetdep5_green; <br>
		select count(*) from asset; <br><br>
		
		truncate  table fyassetdep5_bak; <br>
		truncate  table fassetdep5_bak;  <br>
		truncate  table fyassetdep5_green_bak; <br>
		truncate  table fassetdep5_green_bak; <br>
		truncate  table asset_bak; <br><br>
			      
		insert into fyassetdep5_bak  select * from fyassetdep5; <br>
		insert into fassetdep5_bak  select * from fassetdep5; <br>
		insert into fyassetdep5_green_bak  select * from fyassetdep5_green; <br>
		insert into fassetdep5_green_bak  select * from fassetdep5_green;  <br>
		insert into asset_bak  select * from asset; <br><br>

	 	P_INSERT_YASSETDEP5 (자산이월)  이월할자산 <br>
	    P_INSERT_ASSETMASTER5_N (차량대금)  <br>
	    P_INSERT_ASSETMOVE3_5_N (자산변경) <br>
	    P_INSERT_ASSETMOVE_GREEN5(정부보조금) <br>
		P_INSERT_ASSETMOVE2_5_N (매각) <br>
	    P_INSERT_ASSET (5년기준)<br><br>
	    
	    예시: P_INSERT_YASSETDEP5(2019)
	     P_INSERT_ASSETMASTER5_N(2020) ,  P_INSERT_ASSETMOVE3_5_N(2020) , P_INSERT_ASSETMOVE_GREEN5(2020), <br>
	     P_INSERT_ASSETMOVE2_5_N(2020), P_INSERT_ASSET(2020) <br>
	     데이타를 한번에 만드는 방식 , 전년 이월후 당해년도 변동분을 반영한후 5년자산을 만드는 방식
	     
	
	</td>
  </tr>
<% } %>

</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
