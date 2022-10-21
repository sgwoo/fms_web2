<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.common.*" %>
<%@ page import="acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
		
	String s_ym 	= request.getParameter("s_ym")==null?"":request.getParameter("s_ym");
	String sh_height= request.getParameter("sh_height")==null?"":request.getParameter("sh_height");
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
		
		

	//검색년월
	Vector s_vt = p_db.getPropResYMList();
	int s_vt_size = s_vt.size();


	if(s_ym.equals("") && s_vt_size > 0 ){
		for(int i = 0 ; i < s_vt_size ; i++){
			Hashtable ht = (Hashtable)s_vt.elementAt(i);
			if(s_ym.equals("") && AddUtil.parseInt(String.valueOf(ht.get("PROP_Y"))) >= AddUtil.getDate2(1)){
				s_ym = String.valueOf(ht.get("PROP_Y"));			
			}						
		}
	}
	
	//1년치 예약분 가져오기
	Vector vt = p_db.getPropResList(s_ym);
	int vt_size = vt.size();
	
	//직원리스트
	Vector users = users = c_db.getUserList("", "", "PROP_RES");	
	int user_size = users.size();
	
	
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
	function search(){
		var fm = document.form1;					
		fm.target="_self";		
		fm.action = "./prop_res_c.jsp";
		fm.submit();		
	}
	
	//제안회의일자 확정
	function confirm_dt(prop_ym, prop_est_dt){
		var SUBWIN="./prop_res_u.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_ym="+prop_ym+"&prop_est_dt="+prop_est_dt;
		window.open(SUBWIN, "ResModify", "left=200, top=200, width=400, height=300, scrollbars=no");		
	}
	
	//참석예약등록	
	function prop_res_reg(){
		var SUBWIN="./prop_res_i.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";
		window.open(SUBWIN, "ResReg", "left=200, top=200, width=400, height=180, scrollbars=no");	
	}
	
	//참석예약취소
	function prop_res_d(prop_ym){
		var fm = document.form1;
					
		if(!confirm('취소하시겠습니까?'))
			return;		
			
		fm.prop_ym.value = prop_ym;
		fm.cmd.value = "d";
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
  <input type='hidden' name="s_width" 	value="<%=s_width%>">   
  <input type='hidden' name="s_height" 	value="<%=s_height%>">  
  <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">   
  <input type='hidden' name="prop_ym" 	value="">   
  <input type='hidden' name="prop_est_dt" value="">   
  <input type='hidden' name="cmd" 	value="">   
  
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > <span class=style5>제안회의참석예약</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>	
	<tr>	  
	  	<td>
	  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
	  		<select name='s_ym'>
	  		<%for(int i = 0 ; i < s_vt_size ; i++){
				Hashtable ht = (Hashtable)s_vt.elementAt(i);%>
				<option value='<%=ht.get("PROP_Y")%>' <%if(s_ym.equals(String.valueOf(ht.get("PROP_Y")))){%>selected<%}%>><%=ht.get("PROP_Y")%>년도</option>
			<%}%>	
			</select>
			&nbsp;&nbsp;
			<a href="javascript:search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
	  	</td>    
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
          				<td width='10%' class='title'>년월</td>
					<td width='15%' class='title'>회의일자</td>											
					<td width='20%' class='title'>제안대상</td>		
					<td width='10%' class='title'>댓글기한</td>
					<td width='45%' class='title'>예약자</td>
				</tr>
				<%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
          			<tr> 
          				<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROP_YM")))%></td>
					<td align="center">
						<%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_PROP_DT")))%>
						(<%=ht.get("WEEKDAY")%>)
						<%if(AddUtil.parseInt(String.valueOf(ht.get("R_PROP_DT"))) > AddUtil.getDate2(4) && nm_db.getWorkAuthUser("전산담당",user_id)){%>
						<%	if(String.valueOf(ht.get("PROP_DT")).equals("")){%>												
						<a href="javascript:confirm_dt('<%=ht.get("PROP_YM")%>', '<%=ht.get("PROP_EST_DT")%>')" onMouseOver="window.status=''; return true" >[확정]</a>
						<%	}else{%>												
						<a href="javascript:confirm_dt('<%=ht.get("PROP_YM")%>', '<%=ht.get("R_PROP_DT")%>')" onMouseOver="window.status=''; return true" >[수정]</a>
						<%	}%>
						<%}%>
					</td>						
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT")))%></td>		
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("COMMENT_END_DT")))%></td>
					<td>&nbsp;
						<%	StringTokenizer st = new StringTokenizer(String.valueOf(ht.get("RES_IDS")), "/");
							while(st.hasMoreTokens()){
								String res_id = st.nextToken();%>
   								<%=c_db.getNameById(res_id,"USER")%>
   								<%if(user_id.equals(res_id)){%>
   								<%	if(AddUtil.parseInt(String.valueOf(ht.get("R_PROP_DT"))) >= AddUtil.getDate2(4)){%>
   								<a href="javascript:prop_res_d('<%=ht.get("PROP_YM")%>')" onMouseOver="window.status=''; return true" >[취소]</a>   								
   								<%	}%>
   								<%}%>
   								&nbsp;
 						<%	}%>
					 	
					</td>
				</tr>					
				<%}%>            
        		</table>
      		</td>   
    	</tr>	
	<tr>	  
	  	<td>※ 제안회의겸 경영회의를 2012년 1월부터 매월 첫째 금요일 오후 3시에 본사에서 개최합니다.</td>    
	</tr>
	<tr>	  
	 <!-- 	<td>※ 제안심사는  심사 1주일전 금요일까지 입력한 건을 대상으로 합니다. 댓글은 심사회의가 있는 주의 수요일까지 입력 바랍니다.</td>    -->
	  	<td>※ 제안심사는  전전월26일~전월 25일까지 입력한 건을 대상으로 합니다. 댓글은   전월 말일까지 입력 바랍니다.</td>    
	</tr>
	<tr>	  
	  	<td>※ 참석자는 사장,팀장3명,차과장 그리고 대전지점,부산지점,영업팀,고객지원팀,총무팀 각 1~2명 총 10명내외로 합니다.</td>    
	</tr>
	<tr>	  
	<!--   	<td>※ 전팀원은 일년에 한번씩 참석합니다. 각팀별로 매월 분산참석을 원칙으로 합니다.</td>    -->
	   	<td>※ 신입직원은 6개월안 1회 참석, 전직원은 1~3년의 기간중 본인 희망에 따라 1회 참석 하는 것을 원칙으로 합니다.</td>    
	</tr>
	<tr>	  
	  	<td>※ 회의후 회식개념의 식사를 합니다 (특근식대 처리)</td>    
	</tr>
	<tr>	  
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미등록 직원</span></td>    
	</tr>	
	<tr>
		<td class=line2></td>
	</tr>	
     	<tr> 
      		<td class=line>
	    		<table border="0" cellspacing="1" cellpadding="0" width=100%>
          			<tr> 
          				<td>
          					<%if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);%>
        							<%if(p_db.getPropResUserCount(s_ym, String.valueOf(user.get("USER_ID")))==0){%>
        							<%	if(user_id.equals(String.valueOf(user.get("USER_ID")))){%>
        							<a href="javascript:prop_res_reg()" onMouseOver="window.status=''; return true" ><%=user.get("USER_NM")%></a>&nbsp;
        							<%	}else{%>
        							<%=user.get("USER_NM")%>&nbsp;
        							<%	}%>
        							<%}%>
                        				
                        			<%	}
        					  }%>
          				</td>
				</tr>
        		</table>
      		</td>   
    	</tr>		
  </table>
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0"  noresize></iframe> 
</body>
</html>