<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_samt.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	
	String st_dt = s_year + s_mon + "01";
	String end_dt = s_year + s_mon + "31";
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");

	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();

	Vector sers = cs_db.getServNewList(acct, gubun1, st_dt, end_dt, s_kd, t_wd, sort, asc, ref_dt1, ref_dt2);
	int ser_size = sers.size();
	
	//out.println(s_year);
	//out.println(s_mon);
	
	String s_ym = s_year + s_mon;
	
	long amt8_old = 0;
	long amt[] = new long[13];
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head>
<title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/table_fix.js?ver=0.8'></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css?ver=0.1">
<link rel=stylesheet type="text/css" href="/include/table_fix.css?ver=0.4">
</head>

<body>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
<input type='hidden' name='acct' value='<%=acct%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">
							<colgroup>
								<col width="63">
				       			<col width="60">
				       			<col width="60">
				       			<col width="40">
				       			<col width="100">
				       			<col width="100">
				       			<col width="34">
				       			<col width="34">
				       			<col width="34">
				       			<col width="87">
				       			<col width="140">
				       			<col width="88">				       			
				       			<col width="71">
				       			<col width="71">
				       			<col width="60">
				       			<col width="170">
				       			<col width="200">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">
				       			<col width="60">
				       			<col width="70">
				       			<col width="80">
				       			<col width="80">
				       			<col width="70">
				       			<col width="40">
				       			<col width="70">
				       		</colgroup>
							<tr>
								<td rowspan="2" class='title title_border' style="width: 63px;">연번</td>
								<td rowspan="2" class='title title_border' style="width: 60px;">견적서</td>
								<td rowspan="2" class='title title_border' style="width: 60px;">정산</td>
								<td rowspan="2" class='title title_border' style="width: 40px;">사고<br>유형</td>
								<td rowspan="2" class='title title_border' style="width: 100px;">피보험자</td>
								<td rowspan="2" class='title title_border' style="width: 100px;">구분</td>
								<td colspan=2  class='title title_border border_bottom_none' style="width: 68px;">과실비율</td>
								<td rowspan="2" class='title title_border' style="width: 34px;">사진</td>
								<td rowspan="2" class='title title_border' style="width: 87px;">차량번호</td>
								<td rowspan="2" class='title title_border' style="width: 140px;">차명</td>
								<td rowspan="2" class='title title_border' style="width: 88px;">정비일자</td>								
					            <td rowspan="2" class='title title_border' style="width: 71px;">입고일자</td>
								<td rowspan="2" class='title title_border' style="width: 71px;">출고일자</td>
					         	<td rowspan="2" class='title title_border' style="width: 60px;">담당자</td>
								<td rowspan="2" class='title title_border' style="width: 170px;">고객</td>			  		
					            <td rowspan="2" class='title title_border' style="width: 200px;">적요</td>
					            <td rowspan="2" class="title title_border" style="width: 80px;">정비금액</td>    
					            <td colspan="5" class="title title_border border_bottom_none" style="width: 370px;">지급내역</td>
					            <td colspan="2" class="title title_border border_bottom_none" style="width: 150px;">면책금</td>
					            <td rowspan="2" width='40' class="title title_border" style="width: 40px;">선택</td> 
					            <td rowspan="2" width='70' class="title title_border" style="width: 70px;">발행</td> 
				           	</tr>
				           	<tr>            
				           		<td class='title title_border' style="width: 34px;">당사</td>
								<td class='title title_border border_right_none' style="width: 34px;">상대</td>								
				                <td class='title title_border' style="width: 80px;">공임</td>
				                <td class='title title_border' style="width: 80px;">부품</td>
				                <td class='title title_border' style="width: 60px;">D/C</td>
				                <td class='title title_border' style="width: 70px;">선입금</td>
				                <td class='title title_border' style="width: 80px;">소계</td>
				                <td class='title title_border' style="width: 80px;">청구</td>
				                <td class='title title_border border_right_none' style="width: 70px;">해지시</td>
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
				<td>
					<div>
						<table class="inner_top_table table_layout">
							<colgroup>
								<col width="63">
				       			<col width="60">
				       			<col width="60">
				       			<col width="40">
				       			<col width="100">
				       			<col width="100">
				       			<col width="34">
				       			<col width="34">
				       			<col width="34">
				       			<col width="87">
				       			<col width="140">
				       			<col width="88">							
				       			<col width="71">
				       			<col width="71">
				       			<col width="60">
				       			<col width="170">
				       			<col width="200">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">
				       			<col width="60">
				       			<col width="70">
				       			<col width="80">
				       			<col width="80">
				       			<col width="70">
				       			<col width="40">
				       			<col width="70">
				       		</colgroup>
						<%if (ser_size > 0) {%>
							<%for (int i = 0; i < ser_size; i++) {
								Hashtable exp = (Hashtable)sers.elementAt(i);				
						
								//if ( !String.valueOf(exp.get("CON_F_NM")).equals("아마존카") ) {
								//	continue;
								//}
				
								// 사고시 당사 과실비율
								int our_fault = 0;
								String ch_fault = "";
								String ch_acc_st = "";
								
								String o_fault = cs_db.getOutFaultPer( (String)exp.get("CAR_MNG_ID"), (String)exp.get("ACCID_ID"));
								
								StringTokenizer token2 = new StringTokenizer(o_fault, "^");
								
								while (token2.hasMoreTokens()) {
									ch_fault = token2.nextToken().trim();
									ch_acc_st = token2.nextToken().trim();
								}
								our_fault = AddUtil.parseInt (ch_fault);

								//소송인경우 소송의 결재비율로 
								if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") ) { 
									our_fault =  AddUtil.parseInt(String.valueOf(exp.get("J_FAULT_PER")));
								}

								long v_sup_amt = AddUtil.parseLong((String)exp.get("SUP_AMT")); //실제공급가
								
								long v_amt = AddUtil.parseLong((String)exp.get("AMT")); //부품

								if ( exp.get("SERV_ST").equals("자차")) {
								//if (ch_acc_st.equals("4")) {
								//		v_amt = v_amt;
								//   }else  {
									v_amt = v_amt * our_fault/100;
								//   }
								}  
				    
								long v_labor = AddUtil.parseLong((String)exp.get("LABOR")); //공임
						 
								if ( exp.get("SERV_ST").equals("자차")) {
								// 	if (ch_acc_st.equals("4")) {
								//		v_labor = v_labor;
								//    }else  {
							        v_labor = v_labor * our_fault/100;
								//   }
				   				}
								 
				 				long v_c_labor = AddUtil.parseLong((String)exp.get("A_LABOR")); //공임 월간 누계 :천만워:dc없음 1~2천만원:10% 2~3천만원:15%, 3천만원이상:20%
				 				 
				 				int v_cnt = AddUtil.parseInt((String)exp.get("CNT"));
				 
				 				long v_cust_amt = AddUtil.parseLong((String)exp.get("CUST_AMT"));
				  				long v_ext_amt = AddUtil.parseLong((String)exp.get("EXT_AMT"));
				   				long v_cls_amt = AddUtil.parseLong((String)exp.get("CLS_AMT"));
				   
				  				long v_dc_sup_amt = AddUtil.parseLong((String)exp.get("DC_SUP_AMT")); //dc 공급가				
				 
				  				v_dc_sup_amt = AddUtil.l_th_rnd_long(v_dc_sup_amt);
				 	 
				 				StringTokenizer token1 = new StringTokenizer((String)exp.get("ITEM"),"^");
				 
								String item1 = "";
								String item2 = "";
				   
								while (token1.hasMoreTokens()) {								
									item1 = token1.nextToken().trim();	//
								 	item2 = token1.nextToken().trim();	//부품								
								}				     
			     
			       				//공임 월간 누계 :천만워:dc없음 1~2천만원:10% 2~3천만원:15%, 3천만원이상:20%				  
								if (i == 0) {
									amt[8] = v_c_labor + v_labor ;	
								} else {
									amt[8] = amt[8]  + v_labor;	
								}
			       				
								int c_rate = 0;
								int vc_rate = 0;
								int jj_amt = 0;
								int jjj_amt = 0;
											 
								long s_dt = AddUtil.parseLong(String.valueOf(exp.get("SS_DT")));
								    
								if (AddUtil.parseInt(t_wd) > 1 && i == 0) {
								    amt8_old = v_c_labor;  //1회차이상인 경우
								}  
								     
								String item3 = "";
								 
								if (String.valueOf(exp.get("CNT")).equals("1")) {
									item3 = item2;
								} else {
								    item3 = item2 + " 외 " +  AddUtil.parseDecimal(v_cnt - 1) + " 건";		  
								}
								
								amt8_old =  amt[8];
							%>
							<tr>
								<td class="content_border center" style="width: 63px;">
									<%=i+1%> <%if (exp.get("USE_YN").equals("N")) {%>(해약)<%}%>
								</td>
			                    <td class="content_border center" style="width: 60px;">
			                    	<%if (!String.valueOf(exp.get("PIC_CNT")).equals("0")) {%> 
										&nbsp;<a href="javascript:openPopP('<%=exp.get("FILE_TYPE")%>','<%=exp.get("ATTACH_SEQ")%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
									<%}%>
			                    </td>
			                    <td class="content_border center" style="width: 60px;">
			                    	<%if ( !String.valueOf(exp.get("SSS_ST")).equals("0") ) {%>
			                    		<%=exp.get("JUNG_ST")%>
					                <%} else {%>
						            	<%if ( String.valueOf(exp.get("REQ_DT")).equals("미청구") ) {%>
						            		<%=exp.get("REQ_DT")%>
						                <%} else {%>
						                	<%=exp.get("JUNG_ST")%>
						                <%}%>
					                <%}%>
			                    </td>
			        		    <td class="content_border center" style="width: 40px;"><%=exp.get("ACCID_ST_NM")%></td>
			        		    <td class="content_border center" style="width: 100px;">
			        		    	<%if ( !String.valueOf(exp.get("CON_F_NM")).equals("아마존카") ) {%>
										<b><font color="blue"><%=Util.subData(String.valueOf(exp.get("CON_F_NM")), 6)%></font></b>
									<%} else {%>
									  	<%=String.valueOf(exp.get("CON_F_NM"))%>					
									<%}%>	 
			        		    </td>
			        		    <td class="content_border center" style="width: 100px;">
			        		    	<%=exp.get("SERV_ST")%> <%if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") ) {%>(소송)<%}%>
			        		    </td>	
			        		    <td class="content_border center" style="width: 34px;"><%=exp.get("OUR_FAULT_PER")%></td>	
			        		    <td class="content_border center" style="width: 34px;"><%=Math.abs(AddUtil.parseInt(String.valueOf(exp.get("OUR_FAULT_PER")))-100)%></td>	
			        		    <td class="content_border center" style="width: 34px;"><%=exp.get("PIC_CNT")%></td>	
			        		    <td class="content_border center" style="width: 87px;"><%=exp.get("CAR_NO")%></td>	
			        		    <td class="content_border center" style="width: 140px;"><%=Util.subData(String.valueOf(exp.get("CAR_NM")), 12)%></td>	
			        		    <td class="content_border center" style="width: 88px;"><%=exp.get("SERV_DT")%></td>							
								<td class="content_border center" style="width: 71px;"><%=exp.get("IPGODT")%></td>
						        <td class="content_border center" style="width: 71px;"><%=exp.get("CHULGODT")%></td>
						        <td class="content_border center" style="width: 60px;"><%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%></td>			  
							  	<td class="content_border left" style="width: 170px;">
							  		&nbsp;<%=Util.subData(String.valueOf(exp.get("CLIENT_NM")), 12)%>
							  	</td>
				  			    <td class="content_border left" style="width: 200px;">
					  			    <%if (String.valueOf(exp.get("CNT")).equals("1")) {%>
					  			    	&nbsp;<%=Util.subData(item2, 15)%>
								  	<%} else {%>
								   		&nbsp;<%=Util.subData(item2, 10)%>&nbsp;외 <%= AddUtil.parseDecimal(v_cnt - 1)%>&nbsp;건		  
								  	<%}%>
				  			    </td>
				  			 	<td class="content_border right" style="width: 80px;"><%=AddUtil.parseDecimal(exp.get("SUP_AMT"))%>&nbsp;</td>      
				                <td class="content_border right" style="width: 80px;"><%=AddUtil.parseDecimal(v_labor - vc_rate)%>&nbsp;</td>
				                <td class="content_border right" style="width: 80px;"><%=AddUtil.parseDecimal(v_amt)%>&nbsp;</td>
				                <td class="content_border right" style="width: 60px;"><%=AddUtil.parseDecimal(v_dc_sup_amt)%>&nbsp;</td>
				                <td class="content_border right" style="width: 70px;"><%=AddUtil.parseDecimal(v_ext_amt)%>&nbsp;</td>
				                <td class="content_border right" style="width: 80px;"><%=AddUtil.parseDecimal(v_labor - vc_rate + v_amt  - v_dc_sup_amt -  v_ext_amt  )%>&nbsp;</td>
				                <td class="content_border right" style="width: 80px;"><%=AddUtil.parseDecimal(exp.get("CUST_AMT"))%>&nbsp;</td>
				                <td class="content_border right" style="width: 70px;"><%=AddUtil.parseDecimal(exp.get("CLS_AMT"))%>&nbsp;</td>				                
		                	  	<td class="content_border center" style="width: 40px;">
				                	<%if ( !String.valueOf(exp.get("SSS_ST")).equals("0") ) {%>-
					                <%} else {%>
						            	<%if (String.valueOf(exp.get("REQ_DT")).equals("미청구") && !String.valueOf(exp.get("PIC_CNT")).equals("0") && exp.get("SETTLE_ST").equals("1") ) {%>
					              			<input type="checkbox" name="ch_cd" value="<%=exp.get("CAR_MNG_ID")%>^<%=exp.get("SERV_ID")%>^" >
						                <%} else {%>-
						                <%} %>
					                <%}%>
				                </td> 
				                <td class="content_border right" style="width: 70px;"><%=exp.get("ACCT_DT")%>&nbsp;</td>
	                	  	</tr>
	                	  	<%
			             		amt[0]   = amt[0] + v_labor;
			             		amt[1]   = amt[1] + v_amt;
			             		amt[2]   = amt[2] + v_amt + v_labor;
			             		amt[3]   = amt[3] + vc_rate;
			             		amt[4]   = amt[4] + v_labor- vc_rate;
			             		amt[5]   = amt[5] + v_amt;
			             		amt[6]   = amt[6] + v_labor - vc_rate + v_amt  - v_dc_sup_amt - v_ext_amt ;
			             		amt[7]   = amt[7] + v_cust_amt;
			             		amt[9]   = amt[9] + v_sup_amt;
			             		amt[10]   = amt[10] + v_dc_sup_amt;
			             		amt[11]   = amt[11] + v_ext_amt;
			             		amt[12]   = amt[12] + v_cls_amt;			      			               
			               	}%>
			               	<tr>
				        		<td colspan="12" class="title content_border center">합계</td>				                
				                <td colspan="5" class="title content_border"></td>
				                <td class="title content_border right" style="width: 80px;"><%=Util.parseDecimal(amt[9])%>&nbsp;</td>
				                <td class="title content_border right" style="width: 80px;"><%=Util.parseDecimal(amt[4])%>&nbsp;</td>
				                <td class="title content_border right" style="width: 80px;"><%=Util.parseDecimal(amt[5])%>&nbsp;</td>
				                <td class="title content_border right" style="width: 60px;"><%=Util.parseDecimal(amt[10])%>&nbsp;</td>
				                <td class="title content_border right" style="width: 70px;"><%=Util.parseDecimal(amt[11])%>&nbsp;</td> 
				                <td class="title content_border right" style="width: 80px;"><%=Util.parseDecimal(amt[6])%>&nbsp;</td>
				                <td class="title content_border right" style="width: 80px;"><%=Util.parseDecimal(amt[7])%>&nbsp;</td>
				                <td class="title content_border right" style="width: 70px;"><%=Util.parseDecimal(amt[12])%>&nbsp;</td>
				                <td class="title content_border center" style="width: 40px;"></td>
		                	  	<td class="title content_border center" style="width: 70px;"></td>
			              	</tr>
			            <%} else {%>  
					       	<tr>
					       		<td colspan="12" class="content_border center">등록된 데이타가 없습니다.</td>
								<td colspan="15" class="content_border center"></td>
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
