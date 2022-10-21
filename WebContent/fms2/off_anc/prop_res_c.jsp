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
	
		
		

	//�˻����
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
	
	//1��ġ ����� ��������
	Vector vt = p_db.getPropResList(s_ym);
	int vt_size = vt.size();
	
	//��������Ʈ
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
	
	//����ȸ������ Ȯ��
	function confirm_dt(prop_ym, prop_est_dt){
		var SUBWIN="./prop_res_u.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_ym="+prop_ym+"&prop_est_dt="+prop_est_dt;
		window.open(SUBWIN, "ResModify", "left=200, top=200, width=400, height=300, scrollbars=no");		
	}
	
	//����������	
	function prop_res_reg(){
		var SUBWIN="./prop_res_i.jsp<%=valus%>&ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";
		window.open(SUBWIN, "ResReg", "left=200, top=200, width=400, height=180, scrollbars=no");	
	}
	
	//�����������
	function prop_res_d(prop_ym){
		var fm = document.form1;
					
		if(!confirm('����Ͻðڽ��ϱ�?'))
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
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>MASTER > <span class=style5>����ȸ����������</span></span></td>
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
				<option value='<%=ht.get("PROP_Y")%>' <%if(s_ym.equals(String.valueOf(ht.get("PROP_Y")))){%>selected<%}%>><%=ht.get("PROP_Y")%>�⵵</option>
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
          				<td width='10%' class='title'>���</td>
					<td width='15%' class='title'>ȸ������</td>											
					<td width='20%' class='title'>���ȴ��</td>		
					<td width='10%' class='title'>��۱���</td>
					<td width='45%' class='title'>������</td>
				</tr>
				<%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
          			<tr> 
          				<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROP_YM")))%></td>
					<td align="center">
						<%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_PROP_DT")))%>
						(<%=ht.get("WEEKDAY")%>)
						<%if(AddUtil.parseInt(String.valueOf(ht.get("R_PROP_DT"))) > AddUtil.getDate2(4) && nm_db.getWorkAuthUser("������",user_id)){%>
						<%	if(String.valueOf(ht.get("PROP_DT")).equals("")){%>												
						<a href="javascript:confirm_dt('<%=ht.get("PROP_YM")%>', '<%=ht.get("PROP_EST_DT")%>')" onMouseOver="window.status=''; return true" >[Ȯ��]</a>
						<%	}else{%>												
						<a href="javascript:confirm_dt('<%=ht.get("PROP_YM")%>', '<%=ht.get("R_PROP_DT")%>')" onMouseOver="window.status=''; return true" >[����]</a>
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
   								<a href="javascript:prop_res_d('<%=ht.get("PROP_YM")%>')" onMouseOver="window.status=''; return true" >[���]</a>   								
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
	  	<td>�� ����ȸ�ǰ� �濵ȸ�Ǹ� 2012�� 1������ �ſ� ù° �ݿ��� ���� 3�ÿ� ���翡�� �����մϴ�.</td>    
	</tr>
	<tr>	  
	 <!-- 	<td>�� ���Ƚɻ��  �ɻ� 1������ �ݿ��ϱ��� �Է��� ���� ������� �մϴ�. ����� �ɻ�ȸ�ǰ� �ִ� ���� �����ϱ��� �Է� �ٶ��ϴ�.</td>    -->
	  	<td>�� ���Ƚɻ��  ������26��~���� 25�ϱ��� �Է��� ���� ������� �մϴ�. �����   ���� ���ϱ��� �Է� �ٶ��ϴ�.</td>    
	</tr>
	<tr>	  
	  	<td>�� �����ڴ� ����,����3��,������ �׸��� ��������,�λ�����,������,��������,�ѹ��� �� 1~2�� �� 10���ܷ� �մϴ�.</td>    
	</tr>
	<tr>	  
	<!--   	<td>�� �������� �ϳ⿡ �ѹ��� �����մϴ�. �������� �ſ� �л������� ��Ģ���� �մϴ�.</td>    -->
	   	<td>�� ���������� 6������ 1ȸ ����, �������� 1~3���� �Ⱓ�� ���� ����� ���� 1ȸ ���� �ϴ� ���� ��Ģ���� �մϴ�.</td>    
	</tr>
	<tr>	  
	  	<td>�� ȸ���� ȸ�İ����� �Ļ縦 �մϴ� (Ư�ٽĴ� ó��)</td>    
	</tr>
	<tr>	  
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̵�� ����</span></td>    
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