<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_samt.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
		
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	String acct_dt = s_year + s_mon + s_day;
	
	String first = request.getParameter("first")==null?"":request.getParameter("first");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	Vector sers = new Vector();
	int ser_size = 0;
	
	if ( !first.equals("Y")) 	sers = cs_db.getServNewJList(acct, gubun1, s_year, s_mon, s_day, s_kd, t_wd, sort, asc);
	ser_size = sers.size();
	
	long amt[] 	= new long[13];
	
	long r_labor = 0;

	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id)){
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

<script language="JavaScript">
var popObj = null;
<!--

	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
	if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		popObj = window.open(theURL,winName,features);
		popObj.location = theURL;
		popObj.focus();
	}	
		
//-->


//정비비 정산 확정 처리   -- 정산이 안된 경우마 가능하도록 
function cal_set_dt1(){
	var fm = document.form1;		
	
	var scd_size 	= toInt(fm.vt_size.value);	
	
	//데이타 확인 
	if (scd_size  == 0 ) {
	  	alert("정산확정을 할 수 없습니다!!!, 데이타가 없습니다.!!!!");
		return;
	}
	
	var scd_cnt = 0;
	
	if ( scd_size < 2) {
		 if (fm.r_set_dt.value != '') {
	    	 scd_cnt=scd_cnt + 1;
	     }	
	} else {
		for(var i = 0 ; i < scd_size ; i ++){	
		
		     if (fm.r_set_dt[i].value != '') {  //실제 정산이 된건인지 
		    	 scd_cnt=scd_cnt + 1;
		     }		
		}
	}
	
	//scd_cnt = 0;
	
	if ( scd_cnt > 0 ) {
		 alert( "정산이 되어있는 건입니다.데이타 셋팅 할 수 없습니다.!!!");
		 return;
	} else {
	
		if(confirm('정산확정하시겠습니까?')){	
			if ( scd_size < 2) {
				fm.action='cus_samt_s2_a1.jsp';	
			} else { 
				fm.action='cus_samt_s2_a.jsp';	
			}
			fm.target='i_no';	
			fm.submit();
		}	
	}
}

</script>

<style type="text/css">
.button {
	border: 1px solid #7d99ca;
	-webkit-border-radius: 3px;
	-moz-border-radius: 3px;
	border-radius: 4px;
	font-size: 10px;
	font-family: 'Nanum Gothic', sans-serif;
	padding: 5px 5px 4px 5px;
	text-decoration: none;
	display: inline-block;
	text-shadow: -1px -1px 0 rgba(0, 0, 0, 0.3);
	font-weight: bold;
	color: #FFFFFF;
	background-color: #a5b8da;
	background-image: -webkit-gradient(linear, left top, left bottom, from(#a5b8da),
		to(#7089b3));
	background-image: -webkit-linear-gradient(top, #a5b8da, #7089b3);
	background-image: -moz-linear-gradient(top, #a5b8da, #7089b3);
	background-image: -ms-linear-gradient(top, #a5b8da, #7089b3);
	background-image: -o-linear-gradient(top, #a5b8da, #7089b3);
	background-image: linear-gradient(to bottom, #a5b8da, #7089b3);
	filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,
		startColorstr=#a5b8da, endColorstr=#7089b3);
}

.button:hover {
	border: 1px solid #5d7fbc;
	background-color: #819bcb;
	background-image: -webkit-gradient(linear, left top, left bottom, from(#819bcb),
		to(#536f9d));
	background-image: -webkit-linear-gradient(top, #819bcb, #536f9d);
	background-image: -moz-linear-gradient(top, #819bcb, #536f9d);
	background-image: -ms-linear-gradient(top, #819bcb, #536f9d);
	background-image: -o-linear-gradient(top, #819bcb, #536f9d);
	background-image: linear-gradient(to bottom, #819bcb, #536f9d);
	filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,
		startColorstr=#819bcb, endColorstr=#536f9d);
}
</style>

</head>

<body>

<form name="form1" id="form1" >
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type='hidden' name='vt_size'  value=<%=ser_size%>>
<input type='hidden' name='acct'  value=<%=acct%>>
<input type='hidden' name='acct_dt'  value=<%=acct_dt%>>

 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'>
 <input type='hidden' name='s_mon' value='<%=s_mon%>'>
 <input type='hidden' name='s_day' value='<%=s_day%>'>
 <input type='hidden' name='sort' value='<%=sort%>'>
 <input type='hidden' name='asc' value='<%=asc%>'>
 
 <table>
 <tr>    
	<td align='left' width=100%>&nbsp;&nbsp;   
	 <%if ( auth_rw.equals("4") || auth_rw.equals("6") ) {%>	      
      <a href='javascript:cal_set_dt1()' onMouseOver="window.status=''; return true" title="클릭하세요" class="button" style="text-decoration: none">정산확정&마감</a> 
     <% } %> 
	</td>
  </tr>	
</table>  
  
<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 800px;">
					<div style="width: 800px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
						
				             <tr> 			               		                    
			                    <td width='10%' class='title title_border'>연번</td>
			                    <td width='9%' class='title title_border'>견적서</td>
			                    <td width='11%' class='title title_border'>정산</td>
			                    <td width='6%' class='title title_border'>사고<br>유형</td>
			                    <td width='10%' class='title title_border'>구분</td>
			                    <td width='10%' class='title title_border'>차량번호</td>
			                    <td width='16%' class='title title_border'>차명</td>
			                    <td width='9%'  class='title title_border' >발행일</td>  
			                    <td width='10%'  class='title title_border' >정산일</td>  
			                    <td width='9%'  class='title title_border' >정비일</td>    			                                               
			                </tr>
						</table>
					</div>
				</td>
				
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							  <colgroup>				       		
				       			<col width="80">
				       			<col width="80">
				       			<col width="80"> 
				       			<col width="60">	       			
				       			<col width="160">
				       			<col width="210">
				       			
				       			<col width="80">
				       			<col width="80">
				       			<col width="70">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80"> <!-- 면책금 -->
				       				       			
				       			<col width="80">	
				       		</colgroup>
				       		
				       		  <tr>
			                    <td width='80'  rowspan=2 class='title title_border'>입고일자</td>                  
			     			    <td width='80'  rowspan=2 class='title title_border'>출고일자</td>         
			                    <td width='80'  rowspan=2 class='title title_border'>등록일자</td>
			                    <td width='60'  rowspan=2 class='title title_border'>담당자</td>
			        			<td width='160' rowspan=2 class='title title_border'>고객</td>			  		
			                    <td width='210' rowspan=2 class='title title_border'>적요</td>              
			                    <td  class="title title_border" colspan=5  >지급내역</td>
			                    <td class="title title_border" colspan=2  >면책금</td>
			                    <td width='80'  class="title title_border" rowspan=2 >발행일</td>                  
			                </tr>
			                <tr>             
			                    <td width='80' class='title title_border'>공임</td>   <!-- 일단위 절사 시행 - 20120223 -->
			                    <td width='80' class='title title_border'>부품</td>    <!-- 일단위 절사 - 20120223 -->
			                    <td width='70' class='title title_border'>D/C</td>    <!--  d/c 공급가 -->
			                    <td width='80' class="title title_border" >선입금</td>
			                    <td width='80' class='title title_border'>소계</td>
			                    <td width='80' class="title title_border" >청구</td>
			                    <td width='80' class='title title_border'>해지시</td>
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
				<td style="width: 800px;">
					<div style="width: 800px;">
						<table class="inner_top_table left_fix">
	     
				 <%	if(ser_size > 0){%>      
			         <%for(int i = 0 ; i < ser_size ; i++){
							Hashtable exp = (Hashtable)sers.elementAt(i);
							
							// 사고시 당사 과실비율
							 int our1_fault = 0;
							 String ch1_fault = "";
							 String ch1_acc_st = "";
							 String ch1_acc_nm = "";
							 
							 String o1_fault= cs_db.getOutFaultPer( (String)exp.get("CAR_MNG_ID"), (String)exp.get("ACCID_ID"));
							
							 StringTokenizer token21 = new StringTokenizer(o1_fault,"^");
							
							 while(token21.hasMoreTokens()) {
									ch1_fault = token21.nextToken().trim();	 
									ch1_acc_st = token21.nextToken().trim();	 			
							 }
							 our1_fault = AddUtil.parseInt (ch1_fault);		
							
							if (   ch1_acc_st.equals("1") ) {
								ch1_acc_nm = "피해";
							} else if (   ch1_acc_st.equals("2") ) {
								ch1_acc_nm = "가해";
							} else if (   ch1_acc_st.equals("3") ) {
							 	ch1_acc_nm = "쌍방";
							} else if (   ch1_acc_st.equals("8") ) {
								ch1_acc_nm = "단독";
							} else if (   ch1_acc_st.equals("6") ) {
								ch1_acc_nm = "수해";	
							} 	
							
							String cal_set_dt = String.valueOf(exp.get("CAL_SET_DT"));
							int cal_jung_st = cs_db.getAcctJung_stNew(acct, cal_set_dt);
							
					//		System.out.println("i=" +i + " | acct=" + acct+ " : cal_set_dt="+ cal_set_dt +" : cal_jung_st = "+ cal_jung_st);
																		    
							%>
			                <tr style="height: 25px;">                                     
			                      <td width='10%' class='center content_border'>			                  		                    
			                    <%=i+1%>
			                    <%if(exp.get("USE_YN").equals("N")){%>   	(해약) 
			                  	<%}%>
			                  	<input type='hidden' name='car_mng_id'  value='<%=exp.get("CAR_MNG_ID")%>' >
			                  	<input type='hidden' name='serv_id'  value='<%=exp.get("SERV_ID")%>' >			                  	
			                    </td>			                 
			                    <td width='9%' class='center content_border'>
			                      <%if(!String.valueOf(exp.get("PIC_CNT")).equals("0")){%> 
			                      &nbsp;<a href="javascript:openPopP('<%=exp.get("FILE_TYPE")%>','<%=exp.get("ATTACH_SEQ")%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
			                      <%}%>    
			                    <td width='11%' class='center content_border'>
			                     <input type='text' name='jung_st'   value='<%=exp.get("SSS_ST")%>' size='4' >	
			                     <input type='hidden' name='cal_jung_st'   value='<%=cal_jung_st%>' >				                  	                  
			                    </td>
			                    <td width='6%' class='center content_border'><%=ch1_acc_nm%></td>
			                    <td width='10%' class='center content_border'><%=exp.get("SERV_ST")%>
			                  	 <% if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") )  {  %>
			                    	(소송)
			               		 <% }%>     
			                    </td>
			                    <td width='10%' class='center content_border'><%=exp.get("CAR_NO")%></td>
			                    <td width='16%' class='left content_border'>&nbsp;<%=Util.subData(String.valueOf(exp.get("CAR_NM")), 9)%></td>
			                    <td width='9%' class='center content_border'><%=exp.get("PRE_SET_DT")%></td>     
			                    <td width='10%' class='center content_border'>
			                     <input type='text' name='set_dt'   value='<%=exp.get("SET_DT")%>' size='6' >	
			                     <input type='hidden' name='r_set_dt'   value='<%=exp.get("SET_DT")%>' size='6' >	
			                     <input type='hidden' name='cal_set_dt'   value='<%=exp.get("CAL_SET_DT")%>' >	
			                    </td>             
			                    <td width='9%' class='center content_border'><%=exp.get("SERV_DT")%></td>            
			                </tr>
			      			 <%		}%>
			        		<tr> 
				        		<td class="title content_border" colspan=10 align='center'>합계</td>
				            
				             </tr>
				      <%} else  {%>  
				            <tr>
						         <td class='center content_border' >등록된 데이타가 없습니다</td>
						    </tr>	              
				     <%}	%>
				         </table>
				     </div>
				 </td>
				 
				 <td>
					<div>
						<table class="inner_top_table table_layout">   				    	    
      
				 <%	if(ser_size > 0){%>  
			             <%for(int i = 0 ; i < ser_size ; i++){
							Hashtable exp = (Hashtable)sers.elementAt(i);
							
							// 사고시 당사 과실비율
							 int our_fault = 0;
							 String ch_fault = "";
							 String ch_acc_st = "";
							 
							 String o_fault= cs_db.getOutFaultPer( (String)exp.get("CAR_MNG_ID"), (String)exp.get("ACCID_ID"));
							
							 StringTokenizer token2 = new StringTokenizer(o_fault,"^");
							
							 while(token2.hasMoreTokens()) {
									ch_fault = token2.nextToken().trim();	 
									ch_acc_st = token2.nextToken().trim();	 			
							 }
							 our_fault = AddUtil.parseInt (ch_fault);
							 //소송인경우 소송의 결재비율로 
							 if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") )  { 
								 our_fault =  AddUtil.parseInt(String.valueOf(exp.get("J_FAULT_PER"))) ;
							 }
							 				 				 
							 long v_sup_amt = AddUtil.parseLong((String)exp.get("SUP_AMT")); //실제공급가
							
							 long v_amt = AddUtil.parseLong((String)exp.get("AMT")); //부품
							 
							 long v_dc_sup_amt = AddUtil.parseLong((String)exp.get("DC_SUP_AMT")); // dc 공급가
							 
							 v_dc_sup_amt  =AddUtil.l_th_rnd_long(v_dc_sup_amt);
							 	 
							 if ( exp.get("SERV_ST").equals("자차")){   			
							 		  v_amt = v_amt * our_fault/100;				 
							 }  
							 
							 //일단위 절사   -20120223
							   v_amt  =AddUtil.l_th_rnd_long(v_amt);
							    
							 long v_labor = AddUtil.parseLong((String)exp.get("LABOR")); //공임
					
							 
							if ( exp.get("SERV_ST").equals("자차")){   			
							 		 v_labor = v_labor * our_fault/100;
							
			   				 }  
							 	//누적할인 없음			   
						//	 long v_c_labor = AddUtil.parseLong((String)exp.get("A_LABOR")); //공임 월간 누계 :천만워:dc없음 1~2천만원:10% 2~3천만원:15%, 3천만원이상:20%
							 				 
							 long v_cnt =  AddUtil.parseLong((String)exp.get("CNT"));
							 
							 long v_cust_amt =  AddUtil.parseLong((String)exp.get("CUST_AMT"));
							 long v_ext_amt =  AddUtil.parseLong((String)exp.get("EXT_AMT"));
							  long v_cls_amt =  AddUtil.parseLong((String)exp.get("CLS_AMT"));
							 
							 StringTokenizer token1 = new StringTokenizer((String)exp.get("ITEM"),"^");
							 
							 String item1 = "";
							 String item2 = "";
							   
						     while(token1.hasMoreTokens()) {
							
							  	 item1 = token1.nextToken().trim();	//
							   	 item2 = token1.nextToken().trim();	//부품								
						     }	
						     			     
						    //공임 월간 누계 :천만워:dc없음 1~2천만원:10% 2~3천만원:15%, 3천만원이상:20%
							  
						 //   if  ( i == 0 ) {
						 //  		amt[8]   = v_c_labor + v_labor ;	
						 //  	}else {
						 //  		amt[8]  = amt[8]  + v_labor;	
						 //  	}
						   			  			    
						    int c_rate = 0;
						    int vc_rate = 0;
						    int jj_amt = 0;
							int jjj_amt = 0;
							
							long s_dt = 	AddUtil.parseLong(String.valueOf(exp.get("SS_DT")));
																		   			    
						//    if ( AddUtil.parseInt(t_wd) > 1 && i == 0) {
						//        amt8_old = v_c_labor;  //1회차이상인 경우
						//    }
						  
						    String item3 = "";
						     
						    if (String.valueOf(exp.get("CNT")).equals("1")) {
			  			         item3 = item2;
						  	}else {
						         item3 = item2 + " 외 " +  AddUtil.parseDecimal(v_cnt - 1) + " 건";		  
						  	}
						  	
						//  	amt8_old =  amt[8];
						  	
						  	//공임 일단위 절사 - 20120223
						  	r_labor = AddUtil.l_th_rnd_long(v_labor - vc_rate);
						  	
				%>		 
					
				           <tr style="height: 25px;"> 
				                <td width='80' class='center content_border'><%=exp.get("IPGODT")%></td>
			                    <td width='80' class='center content_border'><%=exp.get("CHULGODT")%></td>
			                     <td width='80' class='center content_border'><%=exp.get("REG_DT")%></td>
			                     <td width='60' class='center content_border'><%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%></td>			  
				    			 <td width='160' class='left content_border'>&nbsp;<%=Util.subData(String.valueOf(exp.get("CLIENT_NM")), 12)%></td>
				      			 <td width='210' class='left content_border'>&nbsp;
			      			    <%if(String.valueOf(exp.get("CNT")).equals("1")){%>
			      			    <%=Util.subData(item2, 15)  %>
			    			  	<%}else{%>
			    			   <%=Util.subData(item2, 10)%>&nbsp;외 <%= AddUtil.parseDecimal(v_cnt - 1)%>&nbsp;건		  
			    			  	<%}%></td>
			      			
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(r_labor)%>&nbsp;</td>
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(v_amt)%>&nbsp;</td>
			                   <td width='70' class='right content_border'><%=AddUtil.parseDecimal(v_dc_sup_amt)%>&nbsp;</td>  
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(v_ext_amt)%>&nbsp;</td>
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(r_labor + v_amt -  v_dc_sup_amt -  v_ext_amt  )%>&nbsp;</td>
			                    <td width='80' class='right content_border'><%=AddUtil.parseDecimal(exp.get("CUST_AMT"))%>&nbsp;</td>            
			                     <td width='80' class='right content_border'><%=AddUtil.parseDecimal(exp.get("CLS_AMT"))%>&nbsp;</td>            
			                    <td width='80' class='center content_border'><%=String.valueOf(exp.get("ACCT_DT"))%></td>
			                     <input type='hidden' name='r_labor'   value='<%=r_labor%>' >
			                     <input type='hidden' name='v_amt'   value='<%=v_amt%>'  >
			                     <input type='hidden' name='v_g_dc_amt'   value='<%=vc_rate%>'  >
			                     <input type='hidden' name='v_ext_amt'   value='<%=v_ext_amt%>' >
			                     <input type='hidden' name='v_dc_amt'   value='<%=v_dc_sup_amt%>' >
			                    
			          
			                </tr>
			               <%	
			               
			             		amt[0]   = amt[0] + AddUtil.l_th_rnd_long( v_labor );
			             		amt[1]   = amt[1] + v_amt;
			             		amt[2]   = amt[2] + v_amt + v_labor;
			             		amt[3]   = amt[3] + vc_rate;
			             		amt[9]   = amt[9] + v_sup_amt;
			             		
			             		amt[4]   = amt[4] + r_labor;
			             		amt[5]   = amt[5] + v_amt;
			             		amt[6]   = amt[6] + r_labor + v_amt - v_dc_sup_amt  - v_ext_amt;
			             		amt[7]   = amt[7] + v_cust_amt;
			             		amt[10]   = amt[10] + v_ext_amt;
			             		amt[11]   = amt[11] + v_dc_sup_amt;
			             		
			             		amt[12]   = amt[12] + v_cls_amt;
			             	      			               
			               	}%>
			         	    <tr> 
			                    <td class='title content_border' colspan=6></td>             
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[4] )%></td>
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[5] )%></td>
			                    <td width='70' class='title content_border right'><%=Util.parseDecimal(amt[11] )%></td>
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[10] )%></td>
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[6] )%></td>
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[7] )%></td>
			                    <td width='80' class='title content_border right'><%=Util.parseDecimal(amt[12] )%></td>
			                    <td width='80' class='title content_border right'>&nbsp;</td>          
			                </tr>
			             <%} else  {%>  
				           	<tr>
						           <td width="1300" colspan="14" class='center content_border'>&nbsp;</td>
						      </tr>	              
				            <%}	%>
							</table>
			            </div>
			      </td>
  			</tr>
		</table>
	</div>
</div>

 <tr> 
    <td>&nbsp;<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe></td>
  </tr>
  

</form>
</body>
</html>

<%if(ser_size >0){%>
<script language="JavaScript">
	parent.form1.j_g_amt.value 	= '<%= amt[0] %>';
	parent.form1.j_b_amt.value 	= '<%= amt[1] %>';
	parent.form1.j_g_dc_amt.value = '<%= amt[3] %>';
	parent.form1.j_ext_amt.value 	= '<%= amt[10] %>';
	parent.form1.j_dc_amt.value 	= '<%= amt[11] %>';
	parent.form1.vt_size.value 	= '<%=ser_size %>';
</script>
<% } %>
