<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.asset.*,acar.user_mng.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");

	String gubun1 	= request.getParameter("gubun1")==null?"2016":request.getParameter("gubun1");   //년도 
	String gubun2 	= request.getParameter("gubun2")==null?"L":request.getParameter("gubun2");    //구분: L:lease, R:rent
	
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //sc 출력라인수
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-70;//현황 라인수만큼 제한 아이프레임 사이즈
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AssetDatabase as_db = AssetDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//자산상각액
	Vector vt = as_db.getAssetCarStat(gubun1, gubun2, gubun, gubun_nm);
	int asset_size = vt.size();		
			
	long t_amt1[] = new long[1];  //기초가액
    long t_amt2[] = new long[1];  
    long t_amt3[] = new long[1];  
    long t_amt4[] = new long[1];  
    long t_amt5[] = new long[1];  
    long t_amt6[] = new long[1];  
    long t_amt7[] = new long[1];   //당기말 충당금  
    long t_amt8[] = new long[1];   //전기말 충당금
     long t_amt9[] = new long[1];   //
    long t_amt11[] = new long[1];   //전기말구매보조금   
    long t_amt12[] = new long[1];   //구매보조금   
    long t_amt13[] = new long[1];   //당기말 구매보조금   
     long t_amt14[] = new long[1];   //전기차 매각시 구매보조금 잔액    
     
    long t100_amt[] = new long[1];   //임대료    
    long t90_amt[] = new long[1];   //임대료    
    long t80_amt[] = new long[1];   //임대료    
    long t70_amt[] = new long[1];   //임대료    
    
    long est1_amt[] = new long[1];   //반영예상 장부가액
    long est2_amt[] = new long[1];   //반영예상 장부가액
    long est3_amt[] = new long[1];   //반영예상 장부가액
    long est4_amt[] = new long[1];   //반영예상 장부가액
    
    long est1_amt_120[] = new long[1];   //반영예상 장부가액 (한도 120%)
    long est2_amt_120[] = new long[1];   //반영예상 장부가액
    long est3_amt_120[] = new long[1];   //반영예상 장부가액
    long est4_amt_120[] = new long[1];   //반영예상 장부가액
       
    long t_amt10[] = new long[1];   //매각처분원가    
    long t_p_amt6[] = new long[1];  
    long t_m_amt6[] = new long[1];   
    
    //20170207 파일처리
    String content_code = "OFF_DOC";
	String content_seq  = "asset"+gubun1;
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	   	
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
 	//스캔등록
	function scan_reg(docs_menu){
		window.open("/fms2/off_doc/reg_scan.jsp?docs_menu=asset&syear=<%=gubun1%>", "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}	
	
//출력하기
function toExcel(){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_asset_s10_excel.jsp";
	fm.submit();
}
//-->
</script>
</head>

<body leftmargin="15">
<form  name="form1"  id="form1"  method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
   <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='asset_code' value=''>
  <input type='hidden' name='height' id="height" value='<%=height%>'>
  
   <table border="0" cellspacing="0" cellpadding="0" width='2000'>
   	<tr><td>&nbsp;
   	 <%if(attach_vt_size > 0 && !gubun1.equals("") ){
			  	  		for (int j = 0 ; j < attach_vt_size ; j++){
			  				Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
			  <a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>&nbsp;
			  				<%if( nm_db.getWorkAuthUser("전산팀",user_id) ){%>			
			  					<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
			  					&nbsp;<a href="javascript:toExcel()">리스트엑셀 </a>
							<%} } }else{%>
			  	<%if( nm_db.getWorkAuthUser("전산팀",user_id) ){%>			
			  		<a href="javascript:scan_reg('<%=content_seq%>')"><img src="/acar/images/center/button_reg_exfile.gif" align="absmiddle" border="0"></a>
			  		
			  	<%}}%>
		</td>	  	
  </tr>
  <tr>
  	<!-- <td  colspan=2>  임대료 설명: 1) 보증금 + 사용기한 임대료 환산금액,  2) 보증금 + 사용기한 임대료 환산금액 (차가 초과시 차가 100%),  3) 보증금 + 실제잔여대여기간 대여료 환산금액  ,  4) 보증금 + 실제잔여대여기간 대여료 환산금액 - 사용기한초과분은 사용기한으로 처리  
  		</td> -->  		
  		<td  colspan=2>  임대료 설명 :&nbsp;&nbsp;&nbsp;  1)보증금 + 사용기한 임대 환산금액 (추정액 포함) &nbsp;&nbsp;&nbsp;  2)보증금 + 사용기한 임대 환산금액 (추정액 미포함) &nbsp;&nbsp;&nbsp;  3)보증금 10% + 사용기한 임대 환산금액 (추정액 포함) &nbsp;&nbsp;&nbsp;  4)보증금 10% + 사용기한 임대 환산금액 (추정액 미포함) 
  		</td>
  </tr>
  </table>

 <div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							  <td class='title title_border' rowspan=2 with=10%>연번</td>        
							  <td width='15%'  rowspan=2 class='title title_border'>자산코드</td>
					          <td width='45%'  rowspan=2 class='title title_border'>자산명</td> 
					          <td width="15%"  rowspan=2 class='title title_border'>취득일자</td>
					          <td width="15%"  rowspan=2 class='title title_border'>매각일자</td>       
             
							</tr>
						</table>
					</div>
				</td>
				<td >	
					<div>	
						<table class="inner_top_table table_layout" style="height: 60px;">		
						   <colgroup>			               
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">				       		
				       			<col width="100">		       			
				       			<col width="100">		       			
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="110">				       		
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="100">
				       			<col width="100">		
				       		</colgroup>
				       		 
			          	  	<tr>
							  <td width="100"  rowspan=2 class='title title_border' >취득가액</td>
							  <td width="100"   rowspan=2 class='title title_border'>전기말충담금</td>		
							  <td width="100"   rowspan=2 class='title title_border'>전기말보조금</td>		
							  <td width="100"   rowspan=2 class='title title_border'>일반상각액</td>		
							  <td width="100"  rowspan=2 class='title title_border'>구매보조금 </td>		
						      <td width="100"  rowspan=2 class='title title_border'>당기말충담금</td>	
						      <td width="100"  rowspan=2 class='title title_border'>보조금잔액(매각)</td>	
						      <td width="100"  rowspan=2 class='title title_border'>당기말보조금</td>	 
							  <td width="110"  rowspan=2 class='title title_border'>당기말장부가액</td>
							  <td class='title title_border' colspan=4>임대료</td>
							  <td class='title title_border' colspan=4>반영예상장부가액</td>
							  <td class='title title_border' colspan=4>반영예상장부가액(한도120%)</td>								
							  <td width="100"  rowspan=2 class='title title_border'>매각액</td>	     			   	
							  <td width="100"  rowspan=2 class='title title_border'>손익</td>	  	   			   	  
							</tr>
							<tr>
							  <td width="110" class='title title_border'>1</td>
							  <td width="110" class='title title_border'>2</td>	
							  <td width="110" class='title title_border'>3</td>	
							  <td width="110" class='title title_border'>4</td>		
							  <td width="110" class='title title_border'>1</td>
							  <td width="110" class='title title_border'>2</td>	
							  <td width="110" class='title title_border'>3</td>	
							  <td width="110" class='title title_border'>4</td>	
							  <td width="110" class='title title_border'>1</td>
							  <td width="110" class='title title_border'>2</td>	
							  <td width="110" class='title title_border'>3</td>	
							  <td width="110" class='title title_border'>4</td>									   			   	  
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
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix"> 
  <% //if(asset_size > 0){%> 
        <%	for(int i = 0 ; i < asset_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
	%>			
					        <tr> 
					          <td  width='10%'  class="content_border center" ><%=i+1%></td>
					          <td  width='15%' class="content_border center"><%=ht.get("ASSET_CODE")%></td>
					          <td  width='45%' class="content_border center"><span title='<%=String.valueOf(ht.get("ASSET_NAME"))%>'><%=Util.subData(String.valueOf(ht.get("ASSET_NAME")), 16)%></span></td>
					          <td  width='15%' class="content_border center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>
					          <td  width='15%' class="content_border center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SALE_DATE")))%></td>					             
					        </tr>
					        <%		}	%>
					        <tr> 
					           <td class='title_p title_border' style='text-align:center;' colspan="5" >합계</td>
					         </tr>
					        <tr> 
					           <td class='title_p title_border' style='text-align:center;' colspan="5" ></td>
					        </tr>
					     </table>
					 </div>            
				 </td>   <!-- left -->   
				 
				<td >	
   				    <div >	
					  <table class="inner_top_table table_layout">	
        <%	for(int i = 0 ; i < asset_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
							
				long t1=0;  //취득액
				long t2=0;  //일반상각액
				long t3=0;  //충담금누계액
				long t4=0; //장부가액
				long t5=0; //매각액
				long t6=0;  //손익 
				long t7=0;  //
				long t8=0;  //전기말 충담금
				long t9=0;  //
				long t11=0;    //전기말구매보조금   
				long t12=0;     //구매보조금   
				long t13=0;  //당기말 구매보조금   
			    long t10=0;  //매각 처분 원가   
			    long t14=0;  //전기차 매각시 구매보조금 잔액    
			   
			    long t100=0;  //임대료 반영 
			    long t90 =0;  //임대료 반영 
			    long t80=0;  //임대료 반영 
			    long t70=0;  //임대료 반영 
			    
			    long est1=0;  //반영예상장부가액 
			    long est2=0;  //반영예상장부가액 
			    long est3=0;  //반영예상장부가액 
			    long est4=0;  //반영예상장부가액 
			    
			    long est1_120=0;  //반영예상장부가액 
			    long est2_120=0;  //반영예상장부가액 
			    long est3_120=0;  //반영예상장부가액 
			    long est4_120=0;  //반영예상장부가액 
			       
				long sale_dt = 0;
								
     		   t1 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")));     
				t2=AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
			   t3 = AddUtil.parseLong(String.valueOf(ht.get("ADEP_AMT")));     
		//		t4=AddUtil.parseLong(String.valueOf(ht.get("JANGBU_AMT")));
				t5=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
				
			  	t8=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")));
			  	t11=AddUtil.parseLong(String.valueOf(ht.get("JUN_GDEP")));
			  	t12=AddUtil.parseLong(String.valueOf(ht.get("GDEP_MAMT")));
			  	t13=AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT")));
			 
				sale_dt=AddUtil.parseLong(String.valueOf(ht.get("SALE_DATE")));
				
				t100=AddUtil.parseLong(String.valueOf(ht.get("ACCOUNT_TAX_AMT1")));
				t90=AddUtil.parseLong(String.valueOf(ht.get("ACCOUNT_TAX_AMT2")));
				t80=AddUtil.parseLong(String.valueOf(ht.get("ACCOUNT_TAX_AMT3")));
				t70=AddUtil.parseLong(String.valueOf(ht.get("ACCOUNT_TAX_AMT4")));
				
				
				if ( sale_dt >0) {				
					t6=t5 - t1 + t3 + t13 ;
			      t14 = t13;
					t3  = 0;
				   t4 = 0; //장부가액 
				 
				   t7= 0;   //당기말충당금
                t9=0;    //당기말 구매보조금 
                t10 = t1 - t8 - t2  -  t13;
                t13 = 0;
               	
                
				} else {
				   t6 = 0;				
				   t4 = t1 - t3 - t13;  
				   t7= t3;
				   t9 =t13;
				   t10 = 0;  
				} 
				
				if ( t4 > t100  ) {						
					est1  = t4;	
					est1_120  = t4;	
				} else  {
					if ( t4*1.2 > t100) {
						est1  = t100;	
						est1_120  =t100;	
					} else {
						est1  = t100;
						est1_120  =  t4*120/100;	
					}				
				}
				
				if ( t4 > t90  ) {						
					est2  = t4;	
					est2_120  = t4;	
				} else  {
					if ( t4*1.2 > t90) {
						est2  = t90;	
						est2_120  =t90;	
					} else {
						est2  = t90;
						est2_120  = t4*120/100;
					}				
				}
				
				if ( t4 > t80  ) {						
					est3  = t4;	
					est3_120  = t4;	
				} else  {
					if ( t4*1.2 > t80) {
						est3  = t80;	
						est3_120  =t80;	
					} else {
						est3  = t80;
						est3_120  = t4*120/100;
					}				
				}
												
				if ( t4 > t70  ) {						
					est4  = t4;	
					est4_120  = t4;	
				} else  {
					if ( t4*1.2 > t70) {
						est4  = t70;	
						est4_120  =t70;	
					} else {
						est4  = t70;
						est4_120  = t4*120/100;
					}				
				}
													
				
				for(int j=0; j<1; j++){
						t_amt1[j] += t1;
						t_amt2[j] += t2;
						t_amt3[j] += t3;
						t_amt4[j] += t4;  //장부가액 
						t_amt5[j] += t5;  //매각액 
						t_amt6[j] += t6;  //손익 
						t_amt7[j] += t7;
						t_amt8[j] += t8;     //전기말 충담금 						
						t_amt9[j] += t9;     //전기말 충담금 
						t_amt11[j] += t11;   //전기말 구매보조금 
						t_amt12[j] += t12;   //구매보조금 
						t_amt13[j] += t13;   //당기말 구매보조금 
						t_amt14[j] += t14;   //당기말 구매보조금 
						
						t_amt10[j] += t10;   //매각 원가   (장부가액) 
						
						t100_amt[j] += t100;   //임대료 
						t90_amt[j] += t90;   //임대료 
						t80_amt[j] += t80;   //임대료 
						t70_amt[j] += t70;   //임대료 
													
						if ( t6 >=0 ) {
							t_p_amt6[j] += t6;
						} else {
							t_m_amt6[j] += t6;
						}
												
						est1_amt[j] += est1;   //반영에상 장부가액 
						est2_amt[j] += est2;   //반영에상 장부가액 
						est3_amt[j] += est3;   //반영에상 장부가액 
						est4_amt[j] += est4;   //반영에상 장부가액 
						
						est1_amt_120[j] += est1_120;   //반영에상 장부가액 (힌더 120%)
						est2_amt_120[j] += est2_120;   //반영에상 장부가액 
						est3_amt_120[j] += est3_120;   //반영에상 장부가액 
						est4_amt_120[j] += est4_120;   //반영에상 장부가액 
									
				}
				
		%>
						<tr>
						  <td  width='100' class='content_border right' ><%=Util.parseDecimal(t1)%></td> 
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t8)%></td>		 
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t11)%></td>		
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t2)%></td>		
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t12)%></td>		 <!--구매보조금 -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t7)%></td>	<!--당기말 충당금 -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t14)%></td>	<!--구매보조금 잔액(매각) -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t9)%></td>	<!-- 당기말 구매보조금 -->			
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t4)%></td>  <!--장부가액 -->	
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t100)%></td>  <!--  임대료 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t90)%></td>  <!--  임대료 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t80)%></td>  <!--  임대료 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t70)%></td>  <!--  임대료 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est1)%></td>  <!--  반영예상 장부가액 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est2)%></td>  <!--  반영예상 장부가액 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est3)%></td>  <!--  반영예상 장부가액 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est4)%></td>  <!--  반영예상 장부가액 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est1_120)%></td>  <!--  반영예상 장부가액 (120%한도)-->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est2_120)%></td>  <!--  반영예상 장부가액 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est3_120)%></td>  <!--  반영예상 장부가액 -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est4_120)%></td>  <!--  반영예상 장부가액 -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t5)%></td>  <!--매각액 -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t6)%></td>  <!--손익 -->		
							
						</tr>
				<%		}	%>
						<tr>
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt1[0])%></td>
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt8[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt11[0])%></td>	
						  <td   width='100'class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt2[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt12[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt7[0])%></td>	
						  <td  width='100'class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt14[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt9[0])%></td>				
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt4[0])%></td>
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t100_amt[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t90_amt[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t80_amt[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t70_amt[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est1_amt[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est2_amt[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est3_amt[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est4_amt[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est1_amt_120[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est2_amt_120[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est3_amt_120[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est4_amt_120[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt5[0])%></td>		
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt6[0])%></td>				  	
						</tr>
						<tr>
						  <td  colspan=14 class='title_p title_border' style='text-align:right;'></td>	
						  <td  colspan=2 class='title_p title_border' style='text-align:right;'>처분수익:<%=Util.parseDecimal(t_amt5[0])%></td>
						  <td  colspan=3 class='title_p title_border' style='text-align:right;'>처분원가:<%=Util.parseDecimal(t_amt10[0])%></td>				
						  <td  colspan=2 class='title_p title_border' style='text-align:right;'>처분이익:<%=Util.parseDecimal(t_p_amt6[0])%></td>
						  <td  colspan=2 class='title_p title_border' style='text-align:right;'>처분손실:<%=Util.parseDecimal(t_m_amt6[0] * (-1))%></td>	  	
						</tr>
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
