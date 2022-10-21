<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	//String dt = "1";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	//if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	Vector vt = cdb.getRentEndCondRmAll(dt, ref_dt1, ref_dt2, gubun3, gubun4 ,gubun5 ,t_wd);
	int vt_size = vt.size();
	
	long total_amt 	= 0;
	long total_amt2	= 0;
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language="JavaScript">
<!--
function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	
<% 
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
		//theForm.action = "./register_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}else{
%>
		if(reg_gubun=="id")
		{
			alert("미등록 상태입니다.");
			return;
		}
		//theForm.action = "./register_r_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}
%>
	theForm.target = "d_content"
	theForm.submit();
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

//-->   
</script>
</head>

<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="rpt_no" value="">
<input type="hidden" name="firm_nm" value="">
<input type="hidden" name="client_nm" value="">
<input type="hidden" name="imm_amt" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 580px;">
					<div style="width: 580px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>							
		        		       	<td width=30 class="title title_border" >연<br>번</td>
		        		       	<td width=60 class="title title_border" >알림톡</td>
			       				<td width=30 class="title title_border" >연체</td>
				          		<td width=120 class="title title_border">계약번호</td>
				          		<td width=100 class="title title_border">상호</td>
				          		<td width=80 class="title title_border">차량번호</td>
				          		<td width="80" class="title title_border">계약개시일</td>
						        <td width="80" class="title title_border">계약만료일</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<tr>
								<td width="80" class="title title_border">스케쥴</td>
			            		<td width="100" class="title title_border">차명</td>
			            		<td width="80" class="title title_border">등록일</td>
			            		<td width="80" class="title title_border">차령만료일</td>
			            		<td width="80" class="title title_border">차령연장여부</td>
			            		<td width="60" class="title title_border">최초영업</td>
			            		<td width="60" class="title title_border">관리담당</td>		
			            		<td width="60" class="title title_border">진행</td>
			            		<td width="80" class="title title_border">진행등록일<br>(10일이내)</td>
			            		<td width="80" class="title title_border">진행등록일<br>(10일이상)</td>
			            		<td width="600" class="title title_border">비고</td>
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
				<td style="width: 580px;">
					<div style="width: 580px;">
						<table class="inner_top_table left_fix">
			 <%	if(vt_size > 0){%>        
				  <% for (int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);%>
		         			 <tr style="height: 27px;"> 
								<td class="center content_border" width=30>
								<a href="javascript:parent.view_memo_settle('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; title='계약진행메모'; return true; " ) ><%= i+1%></a></td>
								<td class="center content_border" width=60><a href="javascript:parent.view_kakao_contract('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_COMP_ID")%>');" class="btn" title='알림톡'><img src=/acar/images/center/button_ntalk.gif align=absmiddle border=0></a></td>
								<td class="center content_border" width=30><%if(!ht.get("DLY_COUNT").equals("0")){%><span style="color:red"><%=ht.get("DLY_COUNT")%></span><%}%></td><!-- 연체건수 2017.11.09 -->
		          				<td class="center content_border" width=120><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='계약관리로 이동'><%=ht.get("RENT_L_CD")%></a></td>
		          				<td class="center content_border" width=100><span title="<%=ht.get("FIRM_NM")%>"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
		            			<td width=80 class="center content_border"><a href="javascript:parent.view_car('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역'><%=ht.get("CAR_NO")%></a></td>
		            			<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
				            	<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
		            		</tr>
					<%}%>
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
			              <% for (int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);							%>
						 <tr style="height: 27px;"> 	
		            		<td width=80 class="center content_border"><a href="javascript:parent.reg_im_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_NO")%>')" onMouseOver="window.status=''; return true" title='임의연장등록으로 이동'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></a></td>
		            		<td width=100 class="center content_border">
		            			<%if(String.valueOf(ht.get("FUEL_KD")).equals("8")){%>
			            		<font color=red>[전]</font><span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),5) %></span>
			            		<%}else{%>
			            		<span title="<%= ht.get("CAR_NM")+" "+ht.get("CAR_NAME") %>">&nbsp;<%= Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")),6) %></span>
			            		<%}%>		            			
		            		</td>
		            		<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
		            		<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_END_DT")))%></td>
		            		<td width=80 class="center content_border"><%=ht.get("CAR_END_YN")%></td>
			                <td width=60 class="center content_border"><%=ht.get("BUS_NM")%></td>
               				<td width=60 class="center content_border"><a href="javascript:parent.req_fee_start_act('계약만료처리요청', '<%=ht.get("FIRM_NM")%> <%=ht.get("CAR_NO")%> : 임의등록 처리필요, 채권잔가반영', '<%=ht.get("MNG_ID")%>')" onMouseOver="window.status=''; return true" title='<%=ht.get("MNG_ID")%> 영업담당자에게 계약기간 경과에 따른 처리 요청 메모/메시지/문자 발송하기'><font color=green><%=ht.get("MNG_NM")%></font></a></td>
               				<td width=60 class="center content_border">
							<a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','','1','','','')" onMouseOver="window.status=''; title='계약진행메모'; return true; " ) >
							<%	if(String.valueOf(ht.get("RE_BUS_NM")).equals("")){%>
							<img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0>
							<%	}else{%>
							<%=ht.get("RE_BUS_NM")%>								
							<%	}%>								
							</a>
							</td>
							<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_CONT_MM_DT")))%></td>
							<td width=80 class="center content_border"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_CONT_MM_DT2")))%></td>
			                <td width=600 class="center content_border"><span title="<%= ht.get("END_CONT_MM_CONTENT")%>">&nbsp;<%= Util.subData(String.valueOf(ht.get("END_CONT_MM_CONTENT")),50) %></span>
			                	<%if(String.valueOf(ht.get("END_CONT_MM_CONTENT")).equals("")){%>
			                	  <span title="<%= ht.get("END_CONT_MM_CONTENT2")%>">&nbsp;<%= Util.subData(String.valueOf(ht.get("END_CONT_MM_CONTENT2")),50) %></span>
			                	<%}%>
			                </td>
		            	</tr>
								<%}%>
			<%} else  {%>  
				       <tr>
					        <td width="1360" colspan="11" class='center content_border'>&nbsp;</td>
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

</body>
</html>