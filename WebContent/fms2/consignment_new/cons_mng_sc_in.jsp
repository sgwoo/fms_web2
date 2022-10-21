<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
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
	
	int count =0;
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	Vector vt = cs_db.getConsignmentMngList(s_kd, t_wd, gubun1, st_dt, end_dt, gubun2);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;	//세차수수료(20190517)
	long total_amt9 = 0;	//법인카드 세차(20220701)
	long total_amt11 = 0;	//외부탁송료(202207)
	long total_amt12 = 0;	//보증수리대행
	long total_amt13 = 0;	//검사대행 
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


function cons_memo(cons, seq)
	{
		window.open("cons_memo.jsp?cons_no="+cons+"&seq="+seq, "cons_memo", "left=10, top=10, width=650, height=300, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	/*회수 데이터 가져오기 */
function init_back_list(step, cons_no, user_id1){
		
	//	alert('11');
		
	//var fm = document.form1;
	//fm.cons_no.value 		= cons_no;
	
	//if(step == '의뢰')			fm.action = 'cons_reg_step4.jsp';
	//else if(step == '수신')		fm.action = 'cons_reg_step4.jsp';
	//else if(step == '정산')		fm.action = 'cons_reg_step4.jsp';
	//else						fm.action = 'cons_reg_step4.jsp';

			
	fm.target = 'd_content';
	fm.submit();
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
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/consignment_new/cons_req_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='req_dt' value='<%=AddUtil.getDate()%>'>    
  

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 500px;">
					<div style="width: 500px;">
						<table class="inner_top_table left_fix" style="height: 80px;">
							<tr>
							   <td width='9%' class='title title_border' style='height:45'>연번</td>
						       <td width='12%' class='title title_border'>상태</td>
						       <td width='23%' class='title title_border'>탁송번호</td>				  
							   <td width='24%' class='title title_border'>탁송업체</td>
						       <td width="10%" class='title title_border'>구분</td>
						       <td width="22%" class='title title_border'>차량번호</td>		
							</tr>
						</table>
					</div>
				</td>
				<td style="width: 2700px;">
					<div style="width: 2700px;">
						<table class="inner_top_table table_layout" style="height: 80px;">
					  	 	<colgroup>
				       		  <col  width='5%'> <!--  rowspan -->
				       		  <col  width='5%'>
				       		  <col  width='6%'>
				       		  <col  width='4%'><!--  colspan -->		       		  
							  <col  width='6%'><!--  colspan -->
							  <col  width='4%'><!--  colspan -->		       		  
							  <col  width='6%'><!--  colspan -->  <!-- 도착시간 -->
							  
							  <col  width='2%'> <!--  rowspan -->
				       		  <col  width='4%'>
				       		  <col  width='3%'>
				       		  <col  width='3%'><!--  rowspan -->	
				       		  <col  width='3%'><!--  rowspan -->	
				       		  	       		  
							  <col  width='3%'><!--  colspan -->
							  <col  width='3%'> <!--  colspan -->
				       		  <col  width='3%'>
				       		  <col  width='3%'>
				       		  <col  width='3%'>
				       		  <col  width='3%'>
				       		  <col  width='3%'>
				       		  <col  width='3%'><!--  colspan -->		       		  
							  <col  width='3%'><!--  colspan -->
							  <col  width='3%'><!--  rowspan -->		       				  
							  <col  width='3%'><!--  rowspan -->
							  
							  <col  width='3%'>		       				  
							  <col  width='6%'><!--  rowspan -->
							  <col  width='4%'>		       				  
							  <col  width='6%'><!--  rowspan -->					 										  
			       			</colgroup>
			       		       		       				       		
		       				<tr>
					          <td width="5%" rowspan="3" class='title title_border'>차명</td>
					          <td width="5%" rowspan="3" class='title title_border'>상호</td>				  
							  <td width='6%' rowspan="3" class='title title_border'>탁송사유</td>				  									
							  <td colspan="2" width='10%' class='title title_border'>출발</td>
							  <td colspan="2" width='10%' class='title title_border'>도착</td>
							  <td width='2%' rowspan="3" class='title title_border'>지불<br>구분</td>
							  <td width='4%' rowspan="3" class='title title_border'>비용<br>구분</td>
							  <td width='3%' rowspan="3" class='title title_border'>고객<br>탁송료</td>				  
							  <td colspan="2" class='title title_border'>법인카드</td>
							  <td colspan="9" class='title title_border'>청구금액</td>
							  <td width='3%' rowspan="3" class='title title_border'>운전자</td>
							  <td width='3%' rowspan="3" class='title title_border'>등록자</td>
							  <td width='3%' rowspan="3" class='title title_border'>의뢰자</td>
							  <td width='6%' rowspan="3" class='title title_border'>의뢰일시</td>										
							  <td width='4%' rowspan="3" class='title title_border'>수신자</td>					
							  <td width='6%' rowspan="3" class='title title_border'>수신일시</td>
							</tr>
							<tr>
							  <td rowspan="2" width='4%' class='title title_border'>장소</td>
						      <td rowspan="2" width='6%' class='title title_border'>시간</td>
						      <td rowspan="2" width='4%' class='title title_border'>장소</td>
						      <td rowspan="2" width='6%' class='title title_border'>시간</td>
						      <td rowspan="2" width='3%' class='title title_border'>유류비</td>
						      <td rowspan="2" width='3%' class='title title_border'>세차비</td>
						      <td rowspan="2" width='3%' class='title title_border'>탁송료</td>						  
						      <td rowspan="2" width='3%' class='title title_border'>유류비</td>
						      <td rowspan="2" width='3%' class='title title_border'>세차비</td>
						      <td rowspan="2" width='3%' class='title title_border'>세차<br>수수료</td>					   
						      <td colspan=4 class='title title_border'>기타</td>
						      <td rowspan="2" width='3%' class='title title_border'>합계</td>
						  </tr>
						  <tr>	
						      <td width='3%' class='title title_border'>외부<br>탁송료</td>				  
						      <td width='3%' class='title title_border'>주차비</td>
						      <td width='3%' class='title title_border'>보증수리<br/>대행</td>
						      <td width='3%' class='title title_border'>검사대행</td>						    
						  </tr>	 
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb" >
			<tr>
				<td style="width: 500px;">
					<div style="width: 500px;">
						<table class="inner_top_table left_fix">	
			<%	if(vt_size > 0)	{%>
			<%		for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						String prev_car_no = String.valueOf(ht.get("CAR_NO"));
						String seq = String.valueOf(ht.get("SEQ"));
						String car_no = "";
						if( prev_car_no.length() > 10 ) {
							car_no = cs_db.getCarNo(String.valueOf(ht.get("CONS_NO")), Integer.parseInt(seq));
						}
						car_no = car_no == "" ? Util.subData(prev_car_no, 8) : car_no;
						%>
							<tr style="height: 25px;"> 
								<td  width='9%' class='center content_border'><%if(ht.get("OFF_NM").equals("(주)아마존탁송")){%><a href="javascript:cons_memo('<%=ht.get("CONS_NO")%>','<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%}%><%=i+1%></a></td>
								<td  width='12%' class='center content_border'><%=ht.get("STEP")%></td>					
								<td  width='23%' class='center content_border'><a href="javascript:parent.view_cons('<%=ht.get("STEP")%>','<%=ht.get("CONS_NO")%>','<%=ht.get("USER_ID1")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CONS_NO")%>-<%=ht.get("SEQ")%></a></td>					
								<td  width='24%' class='center content_border'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></td>
								<td  width='10%' class='center content_border'><%=ht.get("CONS_ST_NM")%></td>					
								<td  width='22%' class='center content_border'><%=car_no%></td>
							</tr>
			  			  <%		}%>
							<tr> 
						        <td  class='title content_border' colspan='6'>&nbsp;</td>
						    </tr>
					 <%} else  {%>  
						   	<tr>
						        <td class='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
					 <%}	%>
					     </table>
					  </div>		
					</td>
					
		 			<td style="width: 2700px;">	
		 			  <div style="width: 2700px;">
					    <table class="inner_top_table table_layout">			
		    	     
			<%	if(vt_size > 0)	{%>
				
			<%		for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
					
						%>
							<tr style="height: 25px;"> 				
								<td  width='5%' class='center content_border'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>
								<td  width='5%' class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
								<td  width='6%' class='center content_border'><span title='<%=ht.get("CONS_CAU_NM")%>'><%=Util.subData(String.valueOf(ht.get("CONS_CAU_NM")), 10)%></span></td>
								<td  width='4%' class='center content_border'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
								<td  width='6%' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("F_DT")))%></td>
								<td  width='4%' class='center content_border'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
								<td  width='6%' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("T_DT")))%></td>
								<td  width='2%' class='center content_border'><%=ht.get("PAY_ST_NM")%></td>
								<td  width='4%' class='center content_border'><%=ht.get("COST_ST_NM")%></td>		
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CUST_AMT")))%></td>
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_CARD_AMT")))%></td>
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_CARD_AMT")))%></td>
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>		
											
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_OTHER_AMT")))%></td>	
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC1_AMT")))%></td>	
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC2_AMT")))%></td>	
								<td  width='3%' class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
								<td width='3%' class='center content_border'><span title='<%=ht.get("DRIVER_NM2")%>'><%=Util.subData(String.valueOf(ht.get("DRIVER_NM2")), 3)%></span></td>
								<td width='3%' class='center content_border'><span title='<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>'><%=Util.subData((c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")), 5)%></span></td>					
								<td width='3%' class='center content_border'><%=ht.get("USER_NM1")%></td>
								<td  width='6%' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("USER_DT1")))%></td>					
								<td  width='4%' class='center content_border'><span title='<%=ht.get("USER_NM2")%>'><%=Util.subData(String.valueOf(ht.get("USER_NM2")), 6)%></span></td>										
								<td  width='6%' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("USER_DT2")))%></td>										
							</tr>
			<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
						total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
						total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
						total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
						total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
						total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("OIL_CARD_AMT")));
						total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("WASH_FEE")));
						total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("WASH_CARD_AMT")));
						
						total_amt11 = total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("CONS_OTHER_AMT")));
						total_amt12 = total_amt12 + AddUtil.parseLong(String.valueOf(ht.get("ETC1_AMT")));
						total_amt13 = total_amt13 + AddUtil.parseLong(String.valueOf(ht.get("ETC2_AMT")));
					}%>
							<tr>	
								<td class='title content_border' colspan='10'>&nbsp;</td>	
								<td class='title content_border right'><%=Util.parseDecimal(total_amt7)%></td>
								<td class='title content_border right'><%=Util.parseDecimal(total_amt9)%></td>
							    <td class='title content_border right'><%=Util.parseDecimal(total_amt1)%></td>		
							
								<td class='title content_border right'><%=Util.parseDecimal(total_amt2)%></td>
								<td class='title content_border right'><%=Util.parseDecimal(total_amt3)%></td>
								<td class='title content_border right'><%=Util.parseDecimal(total_amt8)%></td>	<!-- 세차수수료(20190517) -->
								<td class='title content_border right'><%=Util.parseDecimal(total_amt11)%></td>			
								<td class='title content_border right'><%=Util.parseDecimal(total_amt4)%></td>
							    <td class='title content_border right'><%=Util.parseDecimal(total_amt12)%></td>			
							    <td class='title content_border right'><%=Util.parseDecimal(total_amt13)%></td>			
								<td class='title content_border right'><%=Util.parseDecimal(total_amt5)%></td>
								<td class='title content_border'>&nbsp;</td>
							    <td class='title content_border'>&nbsp;</td>
							    <td class='title content_border'>&nbsp;</td>
							    <td class='title content_border'>&nbsp;</td>
							    <td class='title content_border'>&nbsp;</td>
							    <td class='title content_border'>&nbsp;</td>
							</tr>	
			<%} else  {%>  
					       <tr>
						       <td width="2700"  colspan="27" class='center content_border'>&nbsp;</td>
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

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
