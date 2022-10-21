<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*"%>
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
	
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = cs_db.getConsignmentConfList(s_kd, t_wd, gubun1);
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
	
	long total_amt11 = 0;	//외부탁송 (202207)
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
		
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		 
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}		
//-->
</script>
</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
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
  <input type='hidden' name='height' id="height" value='<%=height%>'>
  
<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 400px;">
					<div style="width: 400px;">
						<table class="inner_top_table left_fix" style="height: 80px;">
							<tr>			          
			                    <td width='10%' class='title title_border' style='height:55'>연번</td>
								<td width='5%' class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
						        <td width='30%' class='title title_border'>탁송번호</td>
								<td width='30%' class='title title_border'>탁송업체</td>
						        <td width="25%" class='title title_border'>차량번호</td>
		          
							</tr>
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 80px;">	
						 	<colgroup>				              
				       			<col width="50">
				       			<col width="90">
				       			<col width="100">
				       			<col width="100">	
				       			<col width="110">	
				       			<col width="130">	
				       			<col width="110">	
				       			<col width="130">	<!--  도착 -->	       			
				       			<col width="50">		       			
				       			<col width="60">
				       			<col width="70">		
				       			<col width="60">
				       			<col width="60">
				       			<col width="80">
				       			<col width="60">
				       			<col width="60">
				       			<col width="60">
				       			<col width="60">
				       			<col width="60">
				       			<col width="60">
				       			<col width="60">
				       			<col width="100">	
				       			<col width="60">
				       			<col width="60">
				       						       			
				       		</colgroup>
				       		
							<tr>
					          <td width="50" rowspan="3" class='title title_border'>구분</td>				
					          <td width="90" rowspan="3" class='title title_border'>청구일자</td>
					          <td width="100" rowspan="3" class='title title_border'>차명</td>
					          <td width="100" rowspan="3" class='title title_border'>상호</td>				  
							  <td colspan="2" class='title title_border'>출발</td>
							  <td colspan="2" class='title title_border'>도착</td>
							  <td width='50' rowspan="3" class='title title_border'>지불<br>구분</td>
							  <td width='60' rowspan="3" class='title title_border'>비용<br>구분</td>
							  <td width='70' rowspan="3" class='title title_border'>고객탁송료</td>				  
							  <td colspan="2" class='title title_border'>법인카드</td>
							  <td colspan="9" class='title title_border'>청구금액</td>
							  <td width='60' rowspan="3" class='title title_border'>운전자</td>
							  <td width='60' rowspan="3" class='title title_border'>의뢰자</td>
							</tr>
							<tr>
							  <td  rowspan="2" width='110' class='title title_border'>장소</td>
						      <td  rowspan="2" width='130' class='title title_border'>시간</td>
						      <td  rowspan="2" width='110' class='title title_border'>장소</td>
						      <td  rowspan="2" width='130' class='title title_border'>시간</td>
						      <td  rowspan="2" width='60' class='title title_border'>유류비</td>
						      <td  rowspan="2" width='60' class='title title_border'>세차비</td>
						      <td  rowspan="2" width='80' class='title title_border'>탁송료</td>
						      <td  rowspan="2" width='60' class='title title_border'>유류비</td>
						      <td  rowspan="2" width='60' class='title title_border'>세차비</td>
						      <td  rowspan="2" width='60' class='title title_border'>세차<br>수수료</td>						  
						      <td colspan=4 class='title title_border'>기타</td>
						      <td  rowspan="2" width='100' class='title title_border'>합계<br/>(법인카드제외)</td>
						 	</tr>  
						 	<tr>	
						      <td width='60' class='title title_border'>외부<br>탁송료</td>				  
						      <td width='60' class='title title_border'>주차비</td>
						      <td width='60' class='title title_border'>보증수리<br/>대행</td>
						      <td width='60' class='title title_border'>검사대행</td>						    
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
				<td style="width: 400px;">
				  <div style="width: 400px;">
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
					car_no = car_no == "" ? prev_car_no : car_no;
					%>
						<tr>
							<td  width='10%' class='center content_border'><%=i+1%></td>
							<td  width='5%' class='center content_border'><input type="checkbox" name="ch_cd" value="<%=ht.get("CONS_NO")%>"></td>					
							<td  width='30%' class='center content_border'><a href="javascript:parent.view_cons('<%=ht.get("CONS_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CONS_NO")%>-<%=ht.get("SEQ")%></a></td>		
							<td  width='30%' class='center content_border'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 7)%></span></td>
							<td  width='25%' class='center content_border'><span title='<%=car_no%>'><%=car_no%></span></td>
						</tr>
				<%		}%>
						<tr>
						  <td class='title content_border'>&nbsp;</td>
						  <td class='title content_border'>&nbsp;</td>
						  <td class='title content_border'>&nbsp;</td>
						  <td class='title content_border'>&nbsp;</td>
						  <td class='title content_border'>&nbsp;</td>
						</tr>
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
		<%	if(vt_size > 0)	{%>		
		<%		for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
						<tr>											
							<td  width='50' class='center content_border'><%=ht.get("CONS_ST_NM")%></td>				
							<td  width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>									
							<td  width='100' class='center content_border'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>
							<td  width='100' class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
							<td  width='110' class='center content_border'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
							<td  width='130' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_DT")))%></td>
							<td  width='110' class='center content_border'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
							<td  width='130' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT")))%></td>
							<td  width='50' class='center content_border'><%=ht.get("PAY_ST_NM")%></td>
							<td  width='60' class='center content_border'><%=ht.get("COST_ST_NM")%></td>		
							<td  width='70' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CUST_AMT")))%></td>
							<td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_CARD_AMT")))%></td>
							<td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_CARD_AMT")))%></td>
							<td  width='80' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>			
							
							<td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>
							<td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
							<td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>		
						    <td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_OTHER_AMT")))%></td>							
							<td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
							<td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC1_AMT")))%></td>		
							<td  width='60' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC2_AMT")))%></td>		
							<td  width='100' class='content_border right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
							<td width='60' class='center content_border'><span title='<%=ht.get("DRIVER_NM")%>'><%=Util.subData(String.valueOf(ht.get("DRIVER_NM")), 3)%></span></td>
							<td width='60' class='center content_border'><%=ht.get("USER_NM1")%></td>
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
						    <td class='title content_border'>&nbsp;</td>
						    <td class='title content_border'>&nbsp;</td>
						    <td class='title content_border'>&nbsp;</td>
						    <td class='title content_border'>&nbsp;</td>
						    <td class='title content_border'>&nbsp;</td>					
						    <td class='title content_border'>&nbsp;</td>					
						    <td class='title content_border'>&nbsp;</td>
						    <td class='title content_border'>&nbsp;</td>
						    <td class='title content_border'>&nbsp;</td>
							<td class='title content_border'>&nbsp;</td>
						    <td class='title content_border'>&nbsp;</td>
							<td class='title content_border right'><%=Util.parseDecimal(total_amt7)%></td>	
							<td class='title content_border right'><%=Util.parseDecimal(total_amt9)%></td>					
							<td class='title content_border right'><%=Util.parseDecimal(total_amt1)%></td>
							
							<td class='title content_border right'><%=Util.parseDecimal(total_amt2)%></td>
							<td class='title content_border right'><%=Util.parseDecimal(total_amt3)%></td>
							<td class='title content_border right'><%=Util.parseDecimal(total_amt8)%></td>
							<td class='title content_border right'><%=Util.parseDecimal(total_amt11)%></td>
							<td class='title content_border right'><%=Util.parseDecimal(total_amt4)%></td>
							<td class='title content_border right'><%=Util.parseDecimal(total_amt12)%></td>
							<td class='title content_border right'><%=Util.parseDecimal(total_amt13)%></td>
							<td class='title content_border right'><%=Util.parseDecimal(total_amt5)%></td>
						    <td class='title content_border'>&nbsp;</td>
						    <td class='title content_border'>&nbsp;</td>
						</tr>
		<%} else  {%>  
			        	<tr>
					          <td width="2700" colspan="27" class='center content_border'>&nbsp;</td>
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
