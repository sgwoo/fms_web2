<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	
	float total_mon = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = d_db.getCarPurPayDocList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
	
	String mng_mode1 = ""; 
	String mng_mode2 = "";
	if(nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){
		mng_mode1 = "A";
	}	
	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) || nm_db.getWorkAuthUser("차량대금팀장결재대행",user_id)){
		mng_mode2 = "A";
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
	
	//전체선택
	function AllSelect2(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch2_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}		
	
	//전체선택
	function AllSelect3(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch3_cd"){		
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
<input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
<input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
<input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='from_page' value='/fms2/car_pur/pur_pay_frame.jsp'>
<input type='hidden' name='doc_no' value=''>
<input type='hidden' name='mode' value=''> 

<div class="tb_wrap" >
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 790px;">
					<div style="width: 790px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
								<td width=30 class='title title_border' style='height:45'>연번</td>
							    <td width=30 class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				  					
								<td width=60 class='title title_border'>&nbsp;<br>구분<br>&nbsp;</td>
					            <td width=180 class='title title_border'><input type="checkbox" name="ch3_all" value="Y" onclick="javascript:AllSelect3();">계약번호</td>
					            <td width=120 class='title title_border'>계출번호</td>
					            <td width=90 class='title title_border'>고객</td>
					            <td width=60 class='title title_border'>최초영업</td>					
			       		        <td width=90 class='title title_border'>차종</td>					
			       		        <td width=80 class='title title_border'>출고예정일</td>					
			       		        <td width=50 class='title title_border'>대여<br>기간</td>	
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
						   <colgroup>
					       		  <col  width='80'> <!--  colspan -->
					       		  <col  width='100'><!--  colspan -->		
					       		  <col  width='30'>
					       		  <col  width='100'>       		  
								  <col  width='70'><!--  colspan -->
								  <col  width='60'><!--  colspan -->		       		  
								  <col  width='100'><!--  colspan -->
								  <col  width='80'> <!--  rowspan -->
					       		  <col  width='80'>
					       		  <col  width='100'>
					       		  <col  width='80'><!--  rowspan -->		       		  
								  <col  width='80'><!--  colspan -->
								  <col  width='100'> <!--  colspan -->
					       		  <col  width='80'>
					       		  <col  width='70'>
					       		  <col  width='100'><!--  colspan -->		       		  
								  <col  width='80'><!--  colspan -->
								  <col  width='80'><!--   -->		       				  
								  <col  width='70'><!--   -->
								  <col  width='100'>		       				  
								  <col  width='80'><!--  colspan -->
								  <col  width='80'>		       				  
								  <col  width='70'><!--  colspan -->	
								  <col  width='100'>		       				  
								  <col  width='80'><!--  colspan -->		
								   <col  width='80'>		       				  
								  <col  width='70'><!--  colspan -->	
								  <col  width='100'>		       				  
								  <col  width='80'><!--  colspan -->	
								  <col  width='80'>		       				  
								  <col  width='70'><!--  colspan -->	
								  <col  width='100'>		       				  
								  <col  width='80'><!--  colspan -->	
								  <col  width='100'><!--  rowspan -->		       				  
								  <col  width='80'><!--  rowspan -->					 										  
					       	</colgroup>
					       		       		       				       		
				       		<tr>
			       		        <td colspan="2" class='title title_border'>취득세</td>
			       		        <td width=30 rowspan='2' class='title title_border'>과세<br>구분</td>
			       		        <td width=100 rowspan='2' class='title title_border'>지출처</td>
							    <td colspan="2" class='title title_border'>결재</td>
							    <td colspan="4" class='title title_border'>구입가격</td>					
							    <td colspan="3" class='title title_border'>선지급</td>
							    <td colspan="4" class='title title_border'>임시운행보험료</td>				  
							    <td colspan="4" class='title title_border'>지출처리예정내역1</td>				  
							    <td colspan="4" class='title title_border'>지출처리예정내역2</td>
							    <td colspan="4" class='title title_border'>지출처리예정내역3</td>
							    <td colspan="4" class='title title_border'>지출처리예정내역4</td>
			       		        <td width=100 rowspan='2' class='title title_border'>합계</td>					
			       		        <td width=80 rowspan='2' class='title title_border'>지출예정일</td>									  				  
						    </tr>
							<tr>
							    <td width=80 class='title title_border'><input type="checkbox" name="ch2_all" value="Y" onclick="javascript:AllSelect2();">명의변경</td>
							    <td width=100 class='title title_border'>금융사</td>
							    <td width=70 class='title title_border'>담당자</td>
							    <td width=60 class='title title_border'>팀장</td>
							    <td width=100 class='title title_border'>소비자가</td>				  				  
						        <td width=80 class='title title_border'>D/C금액</td>
						        <td width=80 class='title title_border'>탁송료</td>				  
						        <td width=100 class='title title_border'>구입가격</td>
						        <td width=80 class='title title_border'>계약금</td>
						        <td width=80 class='title title_border'>지출일자</td>					
							    <td width=100 class='title title_border'>잔액</td>		
							    <td width=80 class='title title_border'>지급수단</td>
							    <td width=70 class='title title_border'>종류</td>				  
							    <td width=100 class='title title_border'>금액</td>
							    <td width=80 class='title title_border'>지출일자</td>					    	  
							    <td width=80 class='title title_border'>지급수단</td>
							    <td width=70 class='title title_border'>종류</td>				  
							    <td width=100 class='title title_border'>금액</td>
							    <td width=80 class='title title_border'>지출일자</td>					    			  				    
							    <td width=80 class='title title_border'>지급수단</td>
							    <td width=70 class='title title_border'>종류</td>				  
							    <td width=100 class='title title_border'>금액</td>
							    <td width=80 class='title title_border'>지출일자</td>	
							    <td width=80 class='title title_border'>지급수단</td>
							    <td width=70 class='title title_border'>종류</td>				  
							    <td width=100 class='title title_border'>금액</td>
							    <td width=80 class='title title_border'>지출일자</td>				    				  
							    <td width=80 class='title title_border'>지급수단</td>
							    <td width=70 class='title title_border'>종류</td>				  
							    <td width=100 class='title title_border'>금액</td>
							    <td width=80 class='title title_border'>지출일자</td>				  				  
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
				<td style="width: 790px;">
					<div style="width: 790px;">
						<table class="inner_top_table left_fix">	  
	
			    <%	if(vt_size > 0){   %>	
			<%
					for(int i = 0 ; i < vt_size ; i++)
					{
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						total_mon 	= total_mon + AddUtil.parseFloat(String.valueOf(ht.get("CON_MON")));
			%>
							<tr>
								<td  width=30 class='center content_border' ><%=i+1%></td>
								<td  width=30 class='center content_border'><%if(String.valueOf(ht.get("PUR_PAY_DT")).equals("")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_L_CD")%>"><%}else{%>-<%}%></td>
								<td  width=60 class='center content_border'><%=ht.get("BIT")%></td>
								<td  width=180 class='center content_border'>
								    <input type="checkbox" name="ch3_cd" value="<%=ht.get("RENT_L_CD")%><%=ht.get("RENT_MNG_ID")%><%=i+1%>">					    
								    <%if(!String.valueOf(ht.get("CAR_GU")).equals("중고차")){%>
								    <a href="javascript:parent.Pur_DocPrint('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=i+1%>')" onMouseOver="window.status=''; return true">[팩스]</a>&nbsp;
								    <%}%>
								    <a href="javascript:parent.view_pur_doc('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_GU")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a>
								</td>
								<td  width=120 class='center content_border'>
									<%if(String.valueOf(ht.get("CAR_GU")).equals("중고차")){%>
									<%=ht.get("EST_CAR_NO")%>
									<%}else{%>
									<%=ht.get("RPT_NO")%>
									<%}%>
								</td>
								<td  width=90  class='center content_border'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"></a></td>
								<td  width=60 class='center content_border'><%=ht.get("USER_NM")%><%//=c_db.getNameById(String.valueOf(ht.get("BUS_ID")),"USER")%></td>					
								<td  width=90  class='center content_border'>&nbsp;<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
								<td  width=80 class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DLV_EST_DT")))%>
									<%if(String.valueOf(ht.get("CAR_GU")).equals("중고차")){%>
									중고차
									<%}%>
								</td>
								<td  width=50 class='center content_border'><%=ht.get("CON_MON")%></td>
							</tr>
					<%		}%>
			                <tr>
			                    <td colspan="8" class='title content_border'>합계</td>
			                    <td class='title content_border'>(평균)</td>
			                    <%-- <td class='title content_border'><%=AddUtil.parseFloatNotDot2(total_mon/vt_size)%></td> --%>
			                    <td class='title content_border'><%=AddUtil.calcMath("ROUND", String.valueOf(total_mon/vt_size), 2)%></td>
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
			    <%	if(vt_size > 0){   %>	   
			    
		<%		for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>			
						<tr>
						    <td  width=80 class='center content_border'><%=ht.get("ACQ_CNG_YN")%>
						      <%if(String.valueOf(ht.get("TRF_ST1")).equals("대출") || String.valueOf(ht.get("TRF_ST1")).equals("카드할부") || String.valueOf(ht.get("TRF_ST2")).equals("카드할부")){%><%}else{%><input type="checkbox" name="ch2_cd" value="<%=ht.get("RENT_MNG_ID")%><%=ht.get("RENT_L_CD")%>"><%}%>
						    </td>
						    <td  width=100 class='center content_border'><span title='<%=c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK")%>'><%=Util.subData(c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK"), 6)%></span></td>
						    <td  width=30 class='center content_border'><%=ht.get("PURC_GU")%></td>
						    <td  width=100 class='center content_border'><%if(String.valueOf(ht.get("DLV_BRCH")).equals("B2B사업운영팀") && String.valueOf(ht.get("CAR_COMP_ID")).equals("0003")){%>삼성<%}%><span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 6)%></span></td>
							<td  width=70 class='center content_border'>
							  <%=ht.get("M_DOC_NO")%>
							  <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
							  <%	if(mng_mode1.equals("A")){%>
							  
							  <%	}else{%>-<%}%>
							  <%}else{%><a href="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
							  <%}%></td>
							<td  width=60 class='center content_border'>
							  <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT2")).equals("")){%>
							  <%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || String.valueOf(ht.get("USER_ID1")).equals(user_id) || mng_mode2.equals("A")){%>
							  <input type="button" name="ACT" value="결재" class="btn" onClick="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');">
							  <%	}else{%>-<%}%>
							  <%}else{%><a href="javascript:parent.doc_action('2', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID2")),"USER")%></a>
							  <%}%></td>
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%>&nbsp;</td>
							<td  width=80 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_DC_AMT")))%>&nbsp;</td>
							<td  width=80 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_SD_AMT")))%>&nbsp;</td>					
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%>&nbsp;</td>
							<td  width=80 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CON_AMT")))%>&nbsp;</td>
							<td  width=80 class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CON_PAY_DT")))%></td>										
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("JAN_AMT")))%>&nbsp;</td>
							<td  width=80 class='center content_border'><%=ht.get("TRF_ST5")%></td>
							<td  width=70 class='center content_border'><span title='<%=ht.get("CARD_KIND5")%>'><%=AddUtil.subData(String.valueOf(ht.get("CARD_KIND5")), 4)%></span></td>
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT5")))%>&nbsp;</td>
							<td  width=80 class='center content_border'>
							  <%if(String.valueOf(ht.get("TRF_PAY_DT5")).equals("")){%>
							  <%	if(String.valueOf(ht.get("DOC_STEP")).equals("3")){%>
							  <%		if(Long.parseLong(String.valueOf(ht.get("TRF_AMT5")))>0 && mng_mode1.equals("A")){%>
							  <input type="button" name="REG" value="지출" class="btn" onClick="javascript:parent.pay_action('<%=ht.get("TRF_ST5")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT5")%>');">
							  <%		}else{%>-<%}%>
							  <%	}%>
							  <%}else{%>
							  <a href="javascript:parent.pay_action('<%=ht.get("TRF_ST5")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT5")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRF_PAY_DT5")))%></a>
							  <%}%>							
							</td>
							<td  width=80 class='center content_border'><%=ht.get("TRF_ST1")%></td>
							<td  width=70 class='center content_border'><span title='<%=ht.get("CARD_KIND1")%>'><%=AddUtil.subData(String.valueOf(ht.get("CARD_KIND1")), 4)%></span></td>
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT1")))%>&nbsp;</td>
							<td  width=80 class='center content_border'>
							  <%if(String.valueOf(ht.get("TRF_PAY_DT1")).equals("")){%>
							  <%	if(String.valueOf(ht.get("DOC_STEP")).equals("3")){%>
							  <%		if(Long.parseLong(String.valueOf(ht.get("TRF_AMT1")))>0 && mng_mode1.equals("A")){%>
							  <input type="button" name="REG" value="지출" class="btn" onClick="javascript:parent.pay_action('<%=ht.get("TRF_ST1")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT1")%>');">
							  <%		}else{%>-<%}%>
							  <%	}%>
							  <%}else{%>
							  <a href="javascript:parent.pay_action('<%=ht.get("TRF_ST1")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT1")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRF_PAY_DT1")))%></a>
							  <%}%>
							</td>					
							<td  width=80 class='center content_border'><%=ht.get("TRF_ST2")%></td>
							<td  width=70 class='center content_border'><span title='<%=ht.get("CARD_KIND2")%>'><%=AddUtil.subData(String.valueOf(ht.get("CARD_KIND2")), 4)%></span></td>
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT2")))%>&nbsp;</td>
							<td  width=80 class='center content_border'>
							  <%if(String.valueOf(ht.get("TRF_PAY_DT2")).equals("")){%>
							  <%	if(String.valueOf(ht.get("DOC_STEP")).equals("3")){%>
							  <%		if(Long.parseLong(String.valueOf(ht.get("TRF_AMT2")))>0 && mng_mode1.equals("A")){%>
							  <input type="button" name="REG" value="지출" class="btn" onClick="javascript:parent.pay_action('<%=ht.get("TRF_ST2")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT2")%>');">
							  <%		}else{%>-<%}%>
							  <%	}%>
							  <%}else{%>
							  <a href="javascript:parent.pay_action('<%=ht.get("TRF_ST2")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT2")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRF_PAY_DT2")))%></a>
							  <%}%></td>					
							<td  width=80 class='center content_border'><%=ht.get("TRF_ST3")%></td>
							<td  width=70 class='center content_border'><span title='<%=ht.get("CARD_KIND3")%>'><%=AddUtil.subData(String.valueOf(ht.get("CARD_KIND3")), 4)%></span></td>
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT3")))%>&nbsp;</td>
							<td  width=80 class='center content_border'>
							  <%if(String.valueOf(ht.get("TRF_PAY_DT3")).equals("")){%>
							  <%	if(String.valueOf(ht.get("DOC_STEP")).equals("3")){%>
							  <%		if(Long.parseLong(String.valueOf(ht.get("TRF_AMT3")))>0 && mng_mode1.equals("A")){%>
							  <input type="button" name="REG" value="지출" class="btn" onClick="javascript:parent.pay_action('<%=ht.get("TRF_ST3")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT3")%>');">
							  <%		}else{%>-<%}%>
							  <%	}%>
							  <%}else{%>
							  <a href="javascript:parent.pay_action('<%=ht.get("TRF_ST3")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT3")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRF_PAY_DT3")))%></a>
							  <%}%></td>					
							<td  width=80 class='center content_border'><%=ht.get("TRF_ST4")%></td>
							<td  width=70 class='center content_border'><span title='<%=ht.get("CARD_KIND4")%>'><%=AddUtil.subData(String.valueOf(ht.get("CARD_KIND4")), 4)%></span></td>
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT4")))%>&nbsp;</td>
							<td  width=80 class='center content_border'>
							  <%if(String.valueOf(ht.get("TRF_PAY_DT4")).equals("")){%>
							  <%	if(String.valueOf(ht.get("DOC_STEP")).equals("3")){%>
							  <%		if(Long.parseLong(String.valueOf(ht.get("TRF_AMT4")))>0 && mng_mode1.equals("A")){%>
							  <input type="button" name="REG" value="지출" class="btn" onClick="javascript:parent.pay_action('<%=ht.get("TRF_ST4")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT4")%>');">
							  <%		}else{%>-<%}%>
							  <%	}%>
							  <%}else{%>
							  <a href="javascript:parent.pay_action('<%=ht.get("TRF_ST4")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("TRF_PAY_DT4")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TRF_PAY_DT4")))%></a>
							  <%}%></td>					
							<td  width=100 class='right content_border'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TRF_AMT")))%>&nbsp;</td>
							<td  width=80 class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_EST_DT")))%></td>
						</tr>
		<%
							total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CAR_C_AMT")));
							total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("CAR_DC_AMT")));
							total_amt11	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("CAR_SD_AMT")));
							total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));
							total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("CON_AMT")));
							total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("JAN_AMT")));
							total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT1")));
							total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT2")));
							total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT3")));
							total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT4")));
							total_amt10	= total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
							total_amt12	= total_amt12 + AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT5")));
				} %>
		                <tr>
		                    <td colspan="6" class='title content_border'>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt1)%>&nbsp;</td>
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt2)%>&nbsp;</td>
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt11)%>&nbsp;</td>				  
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt3)%>&nbsp;</td>
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt4)%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right'>&nbsp;</td>					
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt5)%>&nbsp;</td>
		                    <td colspan="2" class='title content_border' style='text-align:right'>&nbsp;</td>
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt12)%>&nbsp;</td>
		                    <td colspan="3" class='title content_border' style='text-align:right'>&nbsp;</td>
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt6)%>&nbsp;</td>
		                    <td colspan="3" class='title content_border'>&nbsp;</td>
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt7)%>&nbsp;</td>
		                    <td colspan="3" class='title content_border'>&nbsp;</td>
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt8)%>&nbsp;</td>
		                    <td colspan="3" class='title content_border'>&nbsp;</td>
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt9)%>&nbsp;</td>
		                    <td class='title content_border'>&nbsp;</td>				  
						    <td class='title content_border' style='text-align:right'><%=Util.parseDecimal(total_amt10)%>&nbsp;</td>
		                    <td class='title content_border'>&nbsp;</td>
		                </tr>
		<%} else  {%>  
				       <tr>
					        <td width="2890" colspan="35" class='center content_border'>&nbsp;</td>
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
	//parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
