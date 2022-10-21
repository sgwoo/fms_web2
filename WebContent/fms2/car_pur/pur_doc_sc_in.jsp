<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
			
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	Vector vt = d_db.getCarPurDocList(s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt);
	int vt_size = vt.size();
	
	int count =0;
	
	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("전산팀",user_id)){
		mng_mode = "A";
	}	
	
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='doc_no' value=''>  
  <input type='hidden' name='mode' value=''>    

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: <%if(!gubun1.equals("0")) { %>670<%}else{%>530<%}%>px;">
					<div style="width: <%if(!gubun1.equals("0")) { %>670<%}else{%>530<%}%>px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>											        		
				        		<td width='40' class='title title_border' >연번</td>
				        		<%if(!gubun1.equals("0")) { %>
								<td width='30' class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
								<%}%>				  					
								<td width='70' class='title title_border'>구분</td>
								<%if(!gubun1.equals("0")) { %>
								<td width='110' class='title title_border'>카드할부</td>
								<%}%>
						        <td width='100' class='title title_border'>계약번호</td>
				        		<td width='80' class='title title_border'>계약일</td>
						        <td width="140" class='title title_border'>고객</td>
						        <td width="50" class='title title_border'>최초<br>영업</td>		
						        <td width="50" class='title title_border'>대여<br>기간</td>
		        
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
						 	<colgroup>
				       		  <col  width='100'> <!--  rowspan -->
				       		  <col  width='100'>
				       		  
				       		  <%if(!gubun1.equals("0")) { %>
				       		  <col  width='80'>
				       		  <%} %>
				       		  <col  width='60'>
				       		  <%if(!gubun1.equals("0")) { %>
				       		  <col  width='60'><!--  colspan -->		       		  							  		       		  
							  <col  width='60'><!--  colspan -->
							  <%} %>
							  
							  <%if(!gubun1.equals("0")) { %>
							  <col  width='80'>
							  <%	if(gubun1.equals("2")) { %>
							  <col  width='80'><!--  rowspan -->
							  <%	} %>
							  <%} %>
							  
							  <%if(!gubun1.equals("2")) { %>
							  <col  width='30'> <!--  rowspan -->				       		  				       		  
				       		  <col  width='70'><!--  rowspan -->		       		  
							  <col  width='80'><!--  colspan -->
							  <%} %>
							 
							  
				       		  <col  width='90'>
				       		  <col  width='80'>
				       		  <col  width='80'>
				       		  
				       		  <col  width='100'> <!--  colspan -->
				       		  <col  width='70'><!--  colspan -->	
				       		  <col  width='150'><!--  colspan -->		       		  
							  <col  width='80'><!--  colspan -->
							  <col  width='80'><!--  colspan -->	
							  	       				  							  
							  <col  width='80'><!--  rowspan -->	 
				       		</colgroup>
				       		    	    
						    <tr>
						        <td width='100' rowspan="2" class='title title_border'>차명</td>
						        <td width='100' rowspan="2" class='title title_border'>계출번호</td>
								<td colspan="<%if(!gubun1.equals("0")) { %>4<%}else{ %>1<%} %>" class='title title_border'>결재</td>
								
								<%if(!gubun1.equals("0")) { %>
								<td width='80' rowspan="2" class='title title_border'>지급요청일</td>
								<%	if(gubun1.equals("2")) { %>
								<td width='80' rowspan="2" class='title title_border'>차량대금<br>지급일자</td>
								<%	} %>
								<%} %>
									
								<%if(!gubun1.equals("2")) { %>					
								<td colspan="3" class='title title_border'>조건</td>
								<%} %>
								
								<td colspan='3' class='title title_border'>탁송</td>
								<td colspan="5" class='title title_border'>출고지점</td>								
								<td width='80' rowspan="2" class='title title_border'>임시운행보험료</td>
						    </tr>
						    <tr>
						        <%if(!gubun1.equals("0")) { %>
								<td width='80' class='title title_border'>기안일</td>
								<%} %>
								<td width='60' class='title title_border'>기안자</td>
								<%if(!gubun1.equals("0")) { %>
								<td width='60' class='title title_border'>출고관리</td>
								<td width='60' class='title title_border'>팀장</td>
								<%} %>
								
								<%if(!gubun1.equals("2")) { %>
								<td width='30' class='title title_border'>스캔</td>
								<td width='70' class='title title_border'>보증보험</td>
								<td width='80'  class='title title_border'>초기선납금</td>
								<%} %>
								
								<td width='90' class='title title_border'>구분</td>
								<td width='80' class='title title_border'>출고지</td>
								<td width='80' class='title title_border'>인수지</td>
								
								<td width='100' class='title title_border'>제조사</td>
								<td width='70' class='title title_border'>구분</td>				  				  
								<td width='150' class='title title_border'>영업소</td>
								<td width='80' class='title title_border'>영업사원</td>
								<td width='80' class='title title_border'>계약금</td>				  
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
				<td style="width: <%if(!gubun1.equals("0")) { %>670<%}else{%>530<%}%>px;">
					<div style="width: <%if(!gubun1.equals("0")) { %>670<%}else{%>530<%}%>px;">
						<table class="inner_top_table left_fix">
					<%	if(vt_size > 0)	{%>
					<%
							for(int i = 0 ; i < vt_size ; i++)
							{
								Hashtable ht = (Hashtable)vt.elementAt(i);
								
								if(String.valueOf(ht.get("RENT_L_CD")).equals("K316KYPR00089")) continue;
								
								count++;
								
								String fine_doc_gov_nm = "";
								
								if(!String.valueOf(ht.get("GOV_ID")).equals("")){
									fine_doc_gov_nm = c_db.getNameById(String.valueOf(ht.get("GOV_ID")), "BANK");
								}
					%>     
				             <tr>
						        <td  width='40' class='center content_border'><a href="javascript:parent.view_memo('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=count%></a></td>
						        <%if(!gubun1.equals("0")) { %>
						        <td  width='30' class='center content_border'><%if(!String.valueOf(ht.get("DOC_STEP")).equals("") && String.valueOf(ht.get("PUR_PAY_DT")).equals("")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("CAR_EST_AMT")%>/<%=ht.get("CON_EST_DT")%>/<%=ht.get("RENT_MNG_ID")%>/<%=ht.get("RENT_L_CD")%>/<%=ht.get("GOV_ID")%>/<%=ht.get("CARD_YN")%>/<%=ht.get("CAR_ST")%>" onclick="javascript:parent.select_purs_amt();"><%}else{%>-<%}%></td>
						        <%} %>
						        <td  width='70' class='center content_border'>
						            <%if(String.valueOf(ht.get("DLV_DT")).equals("") && (String.valueOf(ht.get("DOC_STEP")).equals("1")||String.valueOf(ht.get("DOC_STEP")).equals("0")) && (mng_mode.equals("A") || String.valueOf(ht.get("USER_ID1")).equals(user_id))){%>
							        <a href="javascript:parent.doc_cancel('<%=ht.get("DOC_NO")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_cancel.gif"  align="absmiddle" border="0"></a>
							    	<%}else{%>
							        <span title='<%=ht.get("DELAY_CONT")%>'>
							        <%	if(String.valueOf(ht.get("BIT")).equals("대기") && AddUtil.parseInt(String.valueOf(ht.get("DELAY_MON"))) > 0){%>
							        <a href="javascript:parent.reg_delay_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">장기</a>
							        <%	}%>
							        <%=ht.get("BIT")%>
							        </span>
							     <%}%>
						        </td>
						        <%if(!gubun1.equals("0")) { %>
						        <td  width='110' class='center content_border'>
						            <%if(String.valueOf(ht.get("APP_DT")).equals("")){%>
						                <%if(String.valueOf(ht.get("CARD_YN")).equals("Y")){%>
						                    <%=fine_doc_gov_nm%>
						                <%}%>
						            <%}else{%>
						                <%if(String.valueOf(ht.get("CARD_YN")).equals("Y")){%><span title='<%=fine_doc_gov_nm%>'><%=AddUtil.substringbdot(fine_doc_gov_nm, 10)%></span><%}%><%=AddUtil.ChangeDate(String.valueOf(ht.get("APP_DT")),"MM/DD")%>
						            <%}%>
						        </td>
						        <%}%>
						        <td  width='100' class='center content_border'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
						        <td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
						        <td  width='140' class='center content_border'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("FIRM_NM")), 17)%></span></td>
						        <td  width='50' class='center content_border'><%=c_db.getNameById(String.valueOf(ht.get("BUS_ID")),"USER")%></td>	
						        <td  width='50' class='center content_border'><%=ht.get("CON_MON")%></td>				
						    </tr>
						  <%		}%>		
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
			<%
				if(vt_size > 0)	{ %>
			<%
					for(int i = 0 ; i < vt_size ; i++)
					{
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("RENT_L_CD")).equals("K316KYPR00089")) continue;
						
						String scan_cnt			= String.valueOf(ht.get("SCAN_CNT"));
						String dlv_dt	 		= String.valueOf(ht.get("DLV_DT"));
						String gi_st 			= String.valueOf(ht.get("GI_ST2"));
						String pp_st 			= String.valueOf(ht.get("PP_ST"));
						String scd_yn 			= String.valueOf(ht.get("SCD_YN"));
						String file_name1		= String.valueOf(ht.get("FILE_NAME1"));
						String file_name2		= String.valueOf(ht.get("FILE_NAME2"));
						String req_dt			= String.valueOf(ht.get("REQ_DT"));
						String sup_dt			= String.valueOf(ht.get("SUP_DT"));
						int chk_cnt = 0;
					
						if(gi_st.equals("미가입")){ gi_st = "가입예정"; }
						if(pp_st.equals("면제") && !gi_st.equals("면제")){ pp_st = "증권대체"; }
			%>			
						    <tr>
								<td  width='100' class='center content_border'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_NM")), 12)%></span></td>				
								<td  width='100' class='center content_border'><%=ht.get("RPT_NO")%></td>
								<%if(!gubun1.equals("0")) { %>				
								<td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("S_USER_DT1")))%></td>
								<%}%>
								<td  width='60' class='center content_border'>
								  <!--기안자-->
								  <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true">
								  	<%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
								  		<img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0">
								  	<%}else{%>
								  		<%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%>
								  	<%}%>
									</a>	
								</td>	
								<%if(!gubun1.equals("0")) { %>							
									<td  width='60' class='center content_border'>
									  <!--출고담당자-->
									  <%if(!String.valueOf(ht.get("USER_DT1")).equals("")){%>
									  <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true">
									  		<%if(String.valueOf(ht.get("USER_DT3")).equals("")){%>
									  		<img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0">
									  		<%}else{%>
									  		<%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%>
									  		<%}%>
									  </a>
									  <%}else{%>-<%}%>
									  </td>
									 
									<td  width='60' class='center content_border'>
									  <!--총무팀장-->
									  <%if(!String.valueOf(ht.get("USER_DT1")).equals("")){%>
									  <a href="javascript:parent.doc_action('<%=ht.get("SCAN_DOC_CNT")%>', <%=chk_cnt%>, '5', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>','<%=ht.get("DOC_BIT")%>','<%=ht.get("CAR_OFF_NM")%>');" onMouseOver="window.status=''; return true">
									  		<%if(String.valueOf(ht.get("USER_DT5")).equals("")){%>
									  		<img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0">
									  		<%}else{%>
									  		<%=c_db.getNameById(String.valueOf(ht.get("USER_ID5")),"USER")%>
									  		<%}%>
									  </a>
									  <%}else{%>-<%}%>
									  </td>
									<%}%>
									<%if(!gubun1.equals("0")) { %>
									<td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CON_EST_DT")))%></td>	
									<%	if(gubun1.equals("2")) { %>
									<td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%></td>
									<%	}%>									
									<%}%>
									
									<%if(!gubun1.equals("2")) { %>
									<td  width='30' class='center content_border'><a href="javascript:parent.view_scan('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%if(scan_cnt.equals("0")){%><font color=red><%}%><%=scan_cnt%><%if(gi_st.equals("0")){%></font><%}%></a><span title='매매주문서 스캔 확인'><%=ht.get("SCAN_15_CNT")%></span></td>														
									<td  width='70' class='center content_border'><%if(gi_st.equals("가입예정")){%><font color=red><%}%><%=gi_st%><%if(gi_st.equals("가입예정")){%></font><%}%></td>
									<td  width='80' class='center content_border'><%if(pp_st.equals("미입금")||pp_st.equals("잔액")){%><font color=red><%}%><span title='<%if(pp_st.equals("입금완료")){%>입금완료<%}else{%><%=Util.parseDecimal(String.valueOf(ht.get("JAN_AMT")))%>원<%}%>'><%if(pp_st.equals("입금완료")){%><%=ht.get("PP_PAY_DT")%><%}else{%><%=pp_st%><%}%></span><%if(pp_st.equals("미입금")||pp_st.equals("잔액")){%></font><%}%><%=ht.get("CONT_RENT_ST_NM")%></td>
									<%}%>
									
									<td  width='90' class='center content_border'>									
									<%if(String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("CONS_ST")).equals("1")){%>
									배달탁송
									<%}else{%>
									        					
									    <!--현대자동차 자체탁송 의뢰--> 
									    <%if(String.valueOf(ht.get("CAR_COMP_NM")).equals("현대자동차(주)")){%>
									    
									    <%	if(!String.valueOf(ht.get("CAR_OFF_NM")).equals("법인판매팀") && !String.valueOf(ht.get("CAR_OFF_NM")).equals("법인판촉팀") && !String.valueOf(ht.get("CAR_OFF_NM")).equals("특판팀")){%>
									        <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
									        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
									    <%			if(String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
									            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
									    <%			}%>    
									        </a>
									    
									    <%	}else{%>
									    <%		if(String.valueOf(ht.get("USER_DT1")).equals("")){%>			        
									        
									    <%		}else{%>
									        <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
									        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
									    <%			if(String.valueOf(ht.get("CONS_ST")).equals("2") && String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
									            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
									    <%			}%>    
									        </a>
									    <%		}%>
									    <%	}%>
									    
									    <%}%>
									    
									    <!--기아자동차 자체탁송 의뢰--> 
									    <%if(String.valueOf(ht.get("CAR_COMP_NM")).equals("기아자동차(주)")){%>			    
						                                <a href="javascript:parent.reg_cons('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
									        <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span>
									    <%			if(String.valueOf(ht.get("OFF_NM")).equals("") && String.valueOf(ht.get("DLV_DT")).equals("")){%>			        
									            <img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle>
									    <%			}%>    
									        </a>			    			    
									    <%}%>
						
									    <!--르노삼성자동차 자체탁송 의뢰--> 
									    <%if(String.valueOf(ht.get("CAR_COMP_NM")).equals("르노코리아자동차(주)")){%>                                
									        <%=ht.get("OFF_NM")%>
									    <%}%>
									    
						            <%}%>
						            
									</td>
									<td  width='80' class='center content_border'><span title='<%=ht.get("DLV_EXT")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("DLV_EXT")), 10)%></span></td>
									<td  width='80' class='center content_border'><%=ht.get("UDT_ST")%></td>
									<td  width='100' class='center content_border'><span title='<%=ht.get("CAR_COMP_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_COMP_NM")), 14)%></span></td>
									<td  width='70' class='center content_border'><%=ht.get("ONE_SELF")%></td>
									<td  width='150' class='center content_border'><span title='<%=ht.get("CAR_OFF_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_OFF_NM")), 19)%></span></td>
									<td  width='80' class='center content_border'><a href="javascript:parent.view_emp('<%=ht.get("EMP_ID")%>')";><span title='<%=ht.get("EMP_NM")%>'><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 5)%></span></a></td>
									<td  width='80' class='center content_border'><!-- <a href="javascript:parent.view_con_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')";>문서</a> --><span title='출고 선수금'><%=ht.get("CON_AMT")%></span></td>					
									
									<td  width='80' class='center content_border'>
										<%if(String.valueOf(ht.get("TRF_PAY_DT5")).equals("") && (String.valueOf(ht.get("CARDNO5")).equals("")||String.valueOf(ht.get("USER_DT1")).equals(""))){%>
											<a href="javascript:parent.reg_trfamt5('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true">
												<%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT5")))%>원
											</a>
										<%}else{%>
											<%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT5")))%>원
										<%}%>
									</td>	
						       </tr>
						 <%		}	%> 		
				      <%} else  {%>  
						       	<tr>
							       <td colspan="<%if(!gubun1.equals("0")) { %>18<%}else{%>15<%} %>" class='center content_border'>&nbsp;</td>
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
