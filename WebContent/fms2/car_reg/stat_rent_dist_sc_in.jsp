<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	Vector vt = ad_db.getStatRentDistList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">
<script language='javascript'>
<!--

	function req_fee_start_act(m_title, m_content, bus_id)
	{
		window.open("/acar/memo/memo_send_mini.jsp?send_id=<%=ck_acar_id%>&m_title="+m_title+"&m_content="+m_content+"&rece_id="+bus_id, "MEMO_SEND", "left=100, top=100, width=520, height=370");
	}
	
 //-->   
</script>

</head>

<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
  <input type='hidden' name='height' id="height" value='<%=height%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_reg/stat_rent_dist_frame.jsp'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 420px;">
					<div style="width: 420px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							    <td width='40' class='title title_border' >연번</td>							    
							    <td width='130' class='title title_border'>계약번호</td>
							    <td width='80' class='title title_border'>계약일</td>
							    <td width='170' class='title title_border'>상호</td>				    
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">											
								<colgroup>
					       			<col width="60"> <!--  colspan -->
					       			<col width="60">
					       			<col width="60">
					       			<col width="70">
					       			<col width="60">
					       			<col width="70">
					       			
					       			<col width="50"><!--  colspan -->		       			
					       			<col width="60"> 
					       			<col width="60">
					       			<col width="60">
					       			<col width="70">
					       			
					       			<col width="50"> <!-- rowspan -->
					       			<col width="100">
					       			<col width="150">
					       			<col width="80">
					       			<col width="60">
					       			<col width="60">		       			
					       			<col width="60">		       			
					       			<col width="60">		       			
					       			<col width="50">	
					       			<col width="50">	
					       			<col width="80">	
					       			<col width="80">		       			
					       		</colgroup>
					       			
								<tr>
								    <td colspan="6" class='title title_border' style="height: 30px;">현재 운행상황</td>
								    <td colspan="5" class='title title_border'>계약만기 예상 운행상황</td>
								    <td rowspan="2" width='50' class='title title_border'>관리<br>담당자</td>
								    <td rowspan="2" width='100' class='title title_border'>차량번호</td>
								    <td rowspan="2" width='150' class='title title_border'>차종</td>
								    <td rowspan="2" width='80' class='title title_border'>대여개시일</td>
								    <td rowspan="2" width='60' class='title title_border'>연간약정<br>운행거리</td>
								    <td rowspan="2" width='60' class='title title_border'>1km당<br>초과운행<br>대여료</td>
								    <td rowspan="2" width='60' class='title title_border'>대여시<br>주행거리</td>
								    <td rowspan="2" width='60' class='title title_border'>현재<br>주행거리</td>
								    <td rowspan="2" width='50' class='title title_border'>차량<br>구분</td>
								    <td rowspan="2" width='50' class='title title_border'>관리<br>구분</td>
								    <td rowspan="2" width='80' class='title title_border'>주행거리<br>확인일</td>
								    <td rowspan="2" width='80' class='title title_border'>최종<br>통화일</td>
								</tr>
								<tr>
								    <td width='60' class='title title_border'>대여경과<br>개월수</td>
								    <td width='60' class='title title_border'>약정<br>운행거리</td>
								    <td width='60' class='title title_border'>경과<br>운행거리</td>
								    <td width='70' class='title title_border'>연환산<br>운행거리</td>
								    <td width='60' class='title title_border'>초과<br>운행거리</td>	
								    <td width='70' class='title title_border'>초과운행<br>대여료</td>
								    
								    <td width='50' class='title title_border'>대여<br>개월수</td>
								    <td width='60' class='title title_border'>약정<br>운행거리</td>
								    <td width='60' class='title title_border'>운행거리</td>
								    <td width='60' class='title title_border'>초과<br>운행거리</td>	
								    <td width='70' class='title title_border'>초과운행<br>대여료</td>
								</tr>
								
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 420px;">
					<div style="width: 420px;">
						<table class="inner_top_table left_fix">
		  
					   <%	if(vt_size > 0){%>
					       <%	for(int i = 0 ; i < vt_size ; i++){
				              Hashtable ht = (Hashtable)vt.elementAt(i);
				        %>
						    <tr style="height: 25px;"> 
						      <td width='40' class='center content_border'><a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=i+1%></a></td>						      
						      <td width='130' class='center content_border'><%=ht.get("RENT_L_CD")%></td>
						      <td width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
						      <td width='170' class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 12)%></span></td>
						    </tr>
						 <%		}	%>
				         <%} else  {%>  
				           	<tr>
						       <td class='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
					     <%}	%>
		            	</table>
		          	 </div>            
			   	 </td>
			   	 <td>
					<div>
						<table class="inner_top_table table_layout">   
					       <%	if(vt_size > 0){%>				 
							<%	for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);%>			
							<tr style="height: 25px;"> 
						        <td width='60' class='center content_border'><%=ht.get("USE_MON")%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("USE_AGREE_DIST")))%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("USE_TODAY_DIST")))%></td>
						        <td width='70' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("USE_YEAR_DIST")))%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("USE_CHA_DIST")))%></td>
						        <td width='70' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("USE_AGREE_DIST_AMT")))%></td>
						        <td width='50' class='center content_border'><%=ht.get("CON_MON")%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("END_AGREE_DIST")))%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("END_TODAY_DIST")))%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("END_CHA_DIST")))%></td>
						        <td width='70' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("END_AGREE_DIST_AMT")))%></td>
						        <td width='50' class='center content_border'><a href="javascript:req_fee_start_act('주행거리 입력착오 수정바람','<%=ht.get("CAR_NO")%> 현재주행거리<%=AddUtil.parseDecimal(String.valueOf(ht.get("TODAY_DIST")))%>km, 연환산주행거리<%=AddUtil.parseDecimal(String.valueOf(ht.get("USE_YEAR_DIST")))%>km -> 입력된 주행거리 확인후 약정거리 초과 안내 필요', '<%=ht.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title='관리담당자에게 주행거리 확인 요청하기' ><%=ht.get("BUS_NM2")%></a></td>
						        <td width='100' class='center content_border'><%=ht.get("CAR_NO")%></td>
						        <td width='150' class='center content_border'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>
						        <td width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGREE_DIST")))%></td>
						        <td width='60' class='right content_border'><%=ht.get("OVER_RUN_AMT")%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("F_DIST")))%></td>
						        <td width='60' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TODAY_DIST")))%></td>
						        <td width='50' class='center content_border'><%=ht.get("CAR_GU")%></td>
						        <td width='50' class='center content_border'><%=ht.get("RENT_WAY")%></td>
						        <td width='80' class='center content_border'><a href="javascript:parent.view_car_service('<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='주행거리확인'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TOT_DT")))%></a></td>
						        <td width='80' class='center content_border'><a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><span title='<%=ht.get("MM_SPEAKER")%> <%=ht.get("MM_CONTENT")%>'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MM_REG_DT")))%></span></a></td>
							</tr>
							 <%		}	%> 		
					      <%} else  {%>  
					       	<tr>
						      	<td width="1560" colspan="23" class='center content_border'>&nbsp;</td>
						     </tr>	              
						   <%}	%>
					    </table>
				  	  </div>
				  </td>
 			 </tr>
		</table>
	</div>
</div>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

