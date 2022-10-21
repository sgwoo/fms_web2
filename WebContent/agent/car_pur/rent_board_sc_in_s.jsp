<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	Vector vt = a_db.getRentBoardList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt, ck_acar_id);
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
  <input type='hidden' name='height' id="height" value='<%=height%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/agent/car_pur/pur_doc_frame.jsp'>
  
<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 390px;">
					<div style="width: 390px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>			          
				               <td width='30' class='title title_border' style='height:45'>연번</td>
							   <td width=30 class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				  									
							   <td width='60' class='title title_border'>구분</td>
			                   <td width="110" class='title title_border'>계약번호</td>
			                   <td width="100" class='title title_border'>고객</td>
			                   <td width="60" class='title title_border'>최초영업</td>			                     
							</tr>					
				
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
					  	 	<colgroup>
				       			<col width="50">
				       			<col width="90">
				       			<col width="90">
				       			<col width="70">
				       			<col width="70">
				       			       			       				       					       			
				       			<col width="120">
				       			<col width="90">
				       			<col width="100">
				       			<col width="90">		 
				       			<col width="90">	  
												      
				       			<col width="90">
				       			<col width="100">			       			
				       			<col width="90">		       			
				       			<col width="140">		
				       			<col width="100">
				       					       						       			
				       			<col width="50">		       			
				       			<col width="70">	
				       				       					   
				       			<col width="70">
				       			<col width="70">		       					       			
				       		</colgroup>
				       		
				       		<tr>
						        <td colspan="5" class='title title_border'>기초사항</td>					
								<td colspan="5" class='title title_border'>차량출고</td>
								<td colspan="5" class='title title_border'>등록진행</td>				  
								<td colspan="2" class='title title_border'>블랙박스</td>				  
								<td colspan="2" class='title title_border'>담당자</td>							  	                 	
			        	    </tr>
			        		<tr>
			        		   	<td width='50' class='title title_border'>용도</td>
							    <td width='90' class='title title_border'>차명</td>
							    <td width='90' class='title title_border'>색상</td>
				 				<td width='70' class='title title_border'>맑은서울</td>	
								<td width='70' class='title title_border'>등록지역</td>
												
							    <td width='120' class='title title_border'>계출번호</td>				  
							    <td width='90' class='title title_border'>출고점</td>
							    <td width='100' class='title title_border'>연락처</td>				  
							    <td width='90' class='title title_border'>출고지</td>				  
								<td width='90' class='title title_border'>인수예정일</td>
																							
								<td width='90' class='title title_border'>지급일자</td>	
								<td width='100' class='title title_border'>취득세명의변경</td>			  
								<td width='90' class='title title_border'>차량번호</td>
								<td width='140' class='title title_border'>차대번호</td>
								<td width='100' class='title title_border'>납품지</td>	
										  				  			  
							    <td width='50' class='title title_border'>유무</td>
							    <td width='70' class='title title_border'>제조사</td>				  				  				  				  
							    <td width='70' class='title title_border'>대여구분</td>
							    <td width='70' class='title title_border'>관리담당</td>				  	
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
				<td style="width: 390px;">
					<div style="width: 390px;">
						<table class="inner_top_table left_fix">
							     <%	if(vt_size > 0) {%>
			<%
					for(int i = 0 ; i < vt_size ; i++)
					{
						Hashtable ht = (Hashtable)vt.elementAt(i);
			%>
							<tr style="height: 25px;"> 
								<td  width='30' class='center content_border'><%=i+1%></td>
								<td  width=30 class='center content_border'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_L_CD")%>"></td>										
								<td  width='60' class='center content_border'><%//=ht.get("SORT1")%><%//=ht.get("SORT2")%><%//=ht.get("SORT3")%><%=ht.get("RENT_ST")%></td>
								<td  width='110' class='center content_border'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>	
								<td  width='100' class='center content_border'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%><span title='<%=ht.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"></a></span></td>
								<td  width='60' class='center content_border'>
								  <a href="javascript:parent.req_fee_start_act('신차 주차장 입고 통보', '<%=ht.get("RPT_NO")%> | <%=ht.get("FIRM_NM")%> | <%=ht.get("CAR_NM")%><%if(String.valueOf(ht.get("CAR_NO")).length()==7){%> | <%=ht.get("CAR_NO")%><%}%> 도착. 2시30분에 탁송보내세요.', '<%=ht.get("BUS_ID")%>', '<%=ht.get("AGENT_EMP_NM")%>', '<%=ht.get("AGENT_EMP_M_TEL")%>')" onMouseOver="window.status=''; return true" title='최초영업자에게 신차 주차장 입고 통보하기'>
								    <%=ht.get("BUS_NM")%>
								  </a>
								</td>							
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
    
			            <%	if(vt_size > 0) {%>	
				  <%		for(int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);%>				
						 <tr style="height: 25px;"> 
							<td  width='50' class='center content_border'><%if(String.valueOf(ht.get("CAR_ST")).equals("리스")){%><font color=red><%}%><%if(String.valueOf(ht.get("CAR_ST")).equals("업무대여")){%>렌트<%}else{%><%=ht.get("CAR_ST")%><%}%><%if(String.valueOf(ht.get("CAR_ST")).equals("리스")){%></font><%}%></td>
							<td  width='90' class='center content_border'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
							<td  width='90' class='center content_border'><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 5)%></span></td>
							<td  width='70' class='center content_border'>
								<%if(String.valueOf(ht.get("ECO_E_TAG")).equals("1")){%>
								발급
								<%}%>
							</td>					
							<td  width='70' class='center content_border'><%=ht.get("CAR_EXT")%></td>		
							<td  width='120' class='center content_border'><%=ht.get("RPT_NO")%></td>					
							<td  width='90' class='center content_border'>
								<%if(String.valueOf(ht.get("DLV_BRCH")).equals("B2B사업운영팀")||String.valueOf(ht.get("DLV_BRCH")).equals("특판팀")||String.valueOf(ht.get("DLV_BRCH")).equals("법인판매팀")||String.valueOf(ht.get("DLV_BRCH")).equals("법인판촉팀")){%>
								  <font color=red><span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 5)%></span></font>
								<%}else{%>  
								  <span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 5)%></span>
								<%}%>
							</td>
							<td  width='100' class='center content_border'><%=ht.get("CAR_OFF_TEL")%></td>
							<td  width='90' class='center content_border'><%=Util.subData(String.valueOf(ht.get("DLV_EXT")), 5)%></td>
							<td  width='90' class='center' content_border><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UDT_EST_DT")))%></td>	
														
							<td  width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%>
							<%if(String.valueOf(ht.get("PUR_PAY_DT")).equals("") && !String.valueOf(ht.get("DOC_USER_DT2")).equals("")){%>
							<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DOC_USER_DT2")))%>
							<%}%>
							</td>
							<td  width='100' class='center content_border'><%if(String.valueOf(ht.get("ACQ_CNG_YN")).equals("있음")){%><span title='<%=c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK")%>'><%=Util.subData(c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK"), 6)%></span><%}%></td>
							<td  width='90' class='center content_border'> <%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%><a href="javascript:parent.reg_estcarno ('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=ht.get("CAR_NO")%> </a><%if(String.valueOf(ht.get("CAR_NO")).equals("")){%><a href="javascript:parent.reg_estcarno('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn"><img src=/acar/images/center/button_in_hmnum.gif align=absmiddle border=0></a><%}%><%}else{%><%=ht.get("CAR_NO")%><%}%></td>
							<td  width='140' class='center content_border'><%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%><a href="javascript:parent.reg_estcarnum('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=ht.get("CAR_NUM")%></a><%if(String.valueOf(ht.get("CAR_NUM")).equals("")){%><a href="javascript:parent.reg_estcarnum('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}%><%}else{%><%=ht.get("CAR_NUM")%><%}%></td>					
							<td  width='100' class='center content_border'><span title='<%=ht.get("RENT_EXT")%>'><%=Util.subData(String.valueOf(ht.get("RENT_EXT")), 6)%></span></td>
							
							<td  width='50' class='center content_border'>
							<%if(String.valueOf(ht.get("TINT_NO2")).equals("")){%>
		                                        <%=ht.get("BLACKBOX_YN_NM")%>
							<%}else{%>
							<%=ht.get("B_YN")%>
							<%}%>		
							</td>
							<td  width='70' class='center content_border'>
							<%if(!String.valueOf(ht.get("TINT_NO2")).equals("")){%>							    
							<span title='<%=ht.get("B_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("B_COM_NM")), 5)%></span>
							<%}%>	
							</td>
								
							<td  width='70' class='center content_border'><%if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){%><font color=red><%}%><%=ht.get("RENT_WAY")%><%if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){%></font><%}%></td>					
							<td  width='70' class='center content_border'><%=ht.get("MNG_NM")%></td>
						</tr>
 <%		}	%> 		
			      <%} else  {%>  
					       	<tr>
						       <td width="1640" colspan="19" class='center content_border'>&nbsp;</td>
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

