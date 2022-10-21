<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_samt.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "04", "03");	
	
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

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
	

	Vector sers = cs_db.getServNewList(acct, gubun1, st_dt, end_dt, s_kd, t_wd, sort, asc);
	int ser_size = sers.size();
	
//	out.println(s_year);
//	out.println(s_mon);
	
	String s_ym =  s_year + s_mon;
	
	int amt1 = 0;

	int amt8_old = 0;
	int amt[] 	= new int[13];
	
%>

<html>
<head>
<title>FMS</title>

<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}	
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	//    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	//    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	
	function init()
	{		
		setupEvents();
	}
	
		//등록하기
	function save(){
		fm = document.form1;
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_all"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("정산 처리할 건을 선택하세요.");
			return;
		}	
		
		if (fm.work_st.value == '') { 	
			alert("정산 회차를 선택하세요.");
			return;
		}	
			
		//정산일 체크	
	//	 alert(fm.exp_dt.value.substring(0,4) + fm.exp_dt.value.substring(5,7) );	 
		if (  fm.exp_dt.value.substring(0,4) + fm.exp_dt.value.substring(5,7)   !=  '<%=s_ym%>') { 
			alert("정비월과 정산월이 맞지 않습니다. 정산일을 확인하세요.");
			return;
		}	
		
		
		if(!confirm("등록하시겠습니까?"))	return;
		fm.action = 'cus_samt_jungsan_a.jsp';
		fm.submit();
	}
	
	
	//수정: 스캔 보기
	function view_map(scan){
		var map_path = scan;
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}		
	
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>

<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>

<body onLoad="javascript:init()">
<form name="form1">
<input type='hidden' name='acct' value='<%=acct%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1650>

   <tr>
        <td  colspan=2>&lt; 정비비 정산 &gt; </td>
    </tr>
  
 
	<tr>
      <td  colspan=2>* 처리내용 : 	  
	     <select name='work_st'>
	    	    <option value=''> -선택- </option>
    			<option value='1'> 1회차 </option>
    			<option value='2'> 2회차 </option>
    			<option value='3'> 3회차 </option>
    			<option value='4'> 4회차 </option>
    			<option value='5'> 5회차 </option>
    			<option value='6'> 6회차 </option>
    			<option value='7'> 7회차 </option>
    			<option value='8'> 8회차 </option>
    			<option value='9'> 9회차 </option>
    			<option value='10'> 10회차 </option>
    			<option value='11'> 11회차 </option>
    			<option value='12'> 12회차 </option>
    			<option value='13'> 13회차 </option>
    			<option value='14'> 14회차 </option>
    			<option value='15'> 15회차 </option>
    			<option value='16'> 16회차 </option>
    			<option value='17'> 17회차 </option>
    			<option value='18'> 18회차 </option>
    			<option value='19'> 19회차 </option>
    			<option value='20'> 20회차 </option>
    			<option value='21'> 21회차 </option>
    			<option value='22'> 221회차 </option>
    			<option value='23'> 23회차 </option>
    			<option value='24'> 24회차 </option>
    			<option value='25'> 25회차 </option>
    			<option value='26'> 26회차 </option>
    			<option value='27'> 27회차 </option>
    			<option value='28'> 28회차 </option>
    			<option value='29'> 29회차 </option>
    			<option value='30'> 30회차 </option>   			
    	</select> 
    	</td>
    	
    	
	</tr>
	
   	<tr>  
	  <td   colspan=2>* 정산일
 	  &nbsp;<input type='text' name='exp_dt' size='12' value='<%=Util.getDate()%>' maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td> 
    </tr>
    
    <tr>
	 <td  colspan=2   style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
		<td align='right'>
		 <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
		  <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;&nbsp;
		  <% } %>
		  <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
		</td>	
		</tr></table>
      </td>
    	
	</tr>	
	
	<tr id='tr_title' >
		
    <td class='line' width='580'> <table border="0" cellspacing="1" cellpadding="0" width='580' height="43">
       <tr> 
            <td width='63'  class='title'>연번</td>
            <td width='60' class='title'>견적서</td>
            <td width='87' class='title'>차량번호</td>
            <td width='140' class='title'>차명</td>
            <td width='88'  class='title' >정비일자</td>
            <td width='71'  class='title'>입고일자</td>
			<td width='71'  class='title'>출고일자</td>
         
       </tr>
      </table></td>
		<td class='line' width='1070'>		
	
	    <table border="0" cellspacing="1" cellpadding="0" width='1070'>
         <tr>
         	<td width='60'  rowspan=2 class='title'>담당자</td>
	<td width='170' rowspan=2 class='title'>고객</td>			  		
            <td width='200' rowspan=2 class='title'>적요</td>
            <td width='80'  class="title" rowspan=2 >정비금액</td>    
            <td  class="title" colspan=5 >지급내역</td>
            <td  class="title" colspan=2 >면책금</td>
            <td width='40'  class=title rowspan=2>선택</td> 
          
          </tr>
           <tr>            
                <td width='80' class='title'>공임</td>
                <td width='80' class='title'>부품</td>
                 <td width='60' class='title'>D/C</td>
                <td width='70' class='title'>선입금</td>
                <td width='80' class='title'>소계</td>
                <td width='80' class='title'>청구</td>
                <td width='70' class='title'>해지시</td>
          </tr>
        </table>
		</td>
		
	</tr>
<%	if(ser_size > 0){%>
	<tr>
		
    <td class='line' width='580' > <table border="0" cellspacing="1" cellpadding="0" width='580'>
         <%for(int i = 0 ; i < ser_size ; i++){
				Hashtable exp = (Hashtable)sers.elementAt(i);%>
         <tr> 
                <td width='63' align='center'><%=i+1%>
                <%if(exp.get("USE_YN").equals("N")){%>
              	(해약) 
              	<%}%>
                </td>
                    <td width='60' align='center'>
                 <%if(!exp.get("SCAN_FILE").equals("")){%>
        			<a href="javascript:view_map('<%=exp.get("SCAN_FILE")%>');" title="견적서를 보시려면 클릭하세요"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                   <% } %>     
                  </td> 
                <td width='87' align='center'><%=exp.get("CAR_NO")%></td>
                <td width='140' align='left'><%=exp.get("CAR_NM")%></td>
                <td width='88' align='center'><%=exp.get("SERV_DT")%></td>
                <td width='71' align='center'><%=exp.get("IPGODT")%></td>
                <td width='71' align='center'><%=exp.get("CHULGODT")%></td>
         </tr>
       <%		}%>
         <tr> 
            <td colspan="7" class=title align=center >합계&nbsp;</td>
         </tr>
      </table></td>
		<td class='line' width='1070'>			
			  <table border="0" cellspacing="1" cellpadding="0" width="1070" >
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
				 				 				 
				 int v_sup_amt = AddUtil.parseInt((String)exp.get("SUP_AMT")); //실제공급가
				
				 int v_amt = AddUtil.parseInt((String)exp.get("AMT")); //부품
				 
				 if ( exp.get("SERV_ST").equals("사고자차")){   
				 	if (ch_acc_st.equals("4")) {
				 		v_amt = v_amt;
				    }else  {
				        v_amt = v_amt * our_fault/100;
				    }
				 }  
				    
				 int v_labor = AddUtil.parseInt((String)exp.get("LABOR")); //공임
				 
						 
				if ( exp.get("SERV_ST").equals("사고자차")){   
				 	if (ch_acc_st.equals("4")) {
				 		v_labor = v_labor;
				    }else  {
				        v_labor = v_labor * our_fault/100;
				    }
   				 }  
				 			   
								 
				 int v_c_labor = AddUtil.parseInt((String)exp.get("A_LABOR")); //공임 월간 누계 :천만워:dc없음 1~2천만원:10% 2~3천만원:15%, 3천만원이상:20%
				 
				 
				 int v_cnt =  AddUtil.parseInt((String)exp.get("CNT"));
				 
				 int v_cust_amt =  AddUtil.parseInt((String)exp.get("CUST_AMT"));
				  int v_ext_amt =  AddUtil.parseInt((String)exp.get("EXT_AMT"));
				   int v_cls_amt =  AddUtil.parseInt((String)exp.get("CLS_AMT"));
				   
				  int v_dc_sup_amt = AddUtil.parseInt((String)exp.get("DC_SUP_AMT")); //dc 공급가				
				 
				 StringTokenizer token1 = new StringTokenizer((String)exp.get("ITEM"),"^");
				 
				 String item1 = "";
				 String item2 = "";
				   
			     while(token1.hasMoreTokens()) {
				
				  	 item1 = token1.nextToken().trim();	//
				   	 item2 = token1.nextToken().trim();	//부품
								
			     }				     
			     
			       //공임 월간 누계 :천만워:dc없음 1~2천만원:10% 2~3천만원:15%, 3천만원이상:20%
				  
			    if  ( i == 0 ) {
			   		amt[8]   = v_c_labor + v_labor ;	
			   	}else {
			   		amt[8]  = amt[8]  + v_labor;	
			   	}
			   
			  			    
			    int c_rate = 0;
			    int vc_rate = 0;
			    int jj_amt = 0;
				int jjj_amt = 0;
							 
				long s_dt = 	AddUtil.parseLong(String.valueOf(exp.get("SS_DT")));
					
					// 2008년 8월 4차까지는 dc 적용, 그후 dc 적용 없음
				if ( s_dt > 200808 || String.valueOf(exp.get("SSS_ST")).equals("0") ){
					 c_rate = 0;
				} else {
					if ( amt[8] > 10000000 &&  amt[8] <= 20000000 ) {
				         c_rate = 10;
				    } else if ( amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         c_rate = 15;
				    } else if ( amt[8] >30000000 ) {
				         c_rate = 20;   
				    } else {
				         c_rate = 0;   
				    }           
				}
					
				    
			    if ( AddUtil.parseInt(t_wd) > 1 && i == 0) {
			        amt8_old = v_c_labor;  //1회차이상인 경우
			    }
			    
			    //공임이 0보다 큰 경우
			    if (v_labor > 0 ) {
				    //최초 dc 구간에 걸리는 경우 
				    if ( amt8_old < 10000000  && amt[8] > 10000000 &&  amt[8] <= 20000000 ) {
				     	 jj_amt = amt[8] - 10000000;
				    } else if (  amt8_old < 20000000  &&  amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         jj_amt = amt[8] - 20000000;
				    } else if ( amt8_old < 30000000   && amt[8] >30000000 ) {
				         jj_amt = amt[8] - 30000000;
				    }
				    
				    
				    // 2천마원, 3천만원 최초 구간인 경우 금액 산정
				    if (  amt8_old < 20000000  &&  amt[8] > 20000000 &&  amt[8] <= 30000000 ) {
				         jjj_amt = (v_labor - jj_amt) * 10/100;
				    } else if ( amt8_old < 30000000   && amt[8] >30000000 ) {
				          jjj_amt = (v_labor - jj_amt) * 15/100;
				    }
			    }
			    
			     	// 2008년 8월 4차까지는 dc 적용, 그후 dc 적용 없음
			    if ( s_dt > 200808 || String.valueOf(exp.get("SSS_ST")).equals("0") ){
			        vc_rate = 0;
			    } else {
				    if(v_labor != 0  )	vc_rate = v_labor*c_rate/100;
				    if(jj_amt !=0 )	  vc_rate = (jj_amt*c_rate/100) + jjj_amt;
			    } 
			    
			  			  	
		//	    if(v_labor != 0  )	vc_rate = v_labor*c_rate/100;
		//	    if(jj_amt !=0 )	  vc_rate = (jj_amt*c_rate/100) + jjj_amt;
			      
			    String item3 = "";
			     
			    if (String.valueOf(exp.get("CNT")).equals("1")) {
  			         item3 = item2;
			  	}else {
			         item3 = item2 + " 외 " +  AddUtil.parseDecimal(v_cnt - 1) + " 건";		  
			  	}
			  	
			  	amt8_old =  amt[8];
	%>		 
		
		      <tr>
                <td width='60' align='center'><%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%></td>			  
			  	<td width='170' align='left'><%=Util.subData(String.valueOf(exp.get("CLIENT_NM")), 12)%></td>
  			    <td width='200' align='left'>&nbsp;
  			    <%if(String.valueOf(exp.get("CNT")).equals("1")){%>
  			    <%=item2 %>
			  	<%}else{%>
			   <%=Util.subData(item2, 10)%>&nbsp;외 <%= AddUtil.parseDecimal(v_cnt - 1)%>&nbsp;건		  
			  	<%}%></td>
  			 	<td width='80' align='right'><%=AddUtil.parseDecimal(exp.get("SUP_AMT"))%>&nbsp;</td>      
		                <td width='80' align='right'><%=AddUtil.parseDecimal(v_labor - vc_rate)%>&nbsp;</td>
		                <td width='80' align='right'><%=AddUtil.parseDecimal(v_amt)%>&nbsp;</td>
		                <td width='60' align='right'><%=AddUtil.parseDecimal(v_dc_sup_amt)%>&nbsp;</td>
		                <td width='70' align='right'><%=AddUtil.parseDecimal(v_ext_amt)%>&nbsp;</td>
		                <td width='80' align='right'><%=AddUtil.parseDecimal(v_labor - vc_rate + v_amt  - v_dc_sup_amt -  v_ext_amt  )%>&nbsp;</td>
		                <td width='80' align='right'><%=AddUtil.parseDecimal(exp.get("CUST_AMT"))%>&nbsp;</td>
		                 <td width='70' align='right'><%=AddUtil.parseDecimal(exp.get("CLS_AMT"))%>&nbsp;</td>
		                <td width='40' align='center'>
		                 <%if(String.valueOf(exp.get("JUNG_ST")).equals("미정산")){%>
		                <input type="checkbox" name="ch_all" value="<%=exp.get("SERV_ST")%>^<%=exp.get("CAR_MNG_ID")%>^<%=exp.get("SERV_ID")%>^<%=exp.get("CAR_NO")%>^<%=exp.get("CAR_NM")%>^<%=exp.get("CLIENT_NM")%>^<%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER_SA")%>^<%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%>^<%=item3%>^<%=v_labor - vc_rate%>^<%=exp.get("AMT")%>^<%=st_dt%>^<%=end_dt%>^" >
		               	<%}else{%>
		                - 
		                <%}%></td> 
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
                <td class=title colspan=3></td>
                <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[9] )%>&nbsp;</td>
                <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[4] )%>&nbsp;</td>
                <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[5] )%>&nbsp;</td>
                <td width='60' class=title style='text-align:right'><%=Util.parseDecimal(amt[10] )%>&nbsp;</td>
                <td width='70' class=title style='text-align:right'><%=Util.parseDecimal(amt[11] )%>&nbsp;</td> 
                <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[6] )%>&nbsp;</td>
                <td width='80' class=title style='text-align:right'><%=Util.parseDecimal(amt[7] )%>&nbsp;</td>
                 <td width='70' class=title style='text-align:right'><%=Util.parseDecimal(amt[12] )%>&nbsp;</td>
                <td class=title></td> 
              </tr>
            </table>
		</td>
	</tr>	
<%	}else{%>
	<tr>
		
      <td class='line' width='580' id='td_con' > <table border="0" cellspacing="1" cellpadding="0" width='580'>
        <tr> 
          <td align='center'>등록된 데이타가 없습니다</td>
        </tr></table>
      </td>
	  <td class='line' width='100%'>			
			<table border="0" cellspacing="1" cellpadding="0" width='1070'>
				<tr>
					<td>&nbsp;</td>
				</tr></table>
	  </td>
	</tr>
<%	} %>
	
</table>
</form>
</body>
</html>
