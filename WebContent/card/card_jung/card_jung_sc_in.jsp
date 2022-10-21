<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

    String s_user =  request.getParameter("user_id")==null?"":request.getParameter("user_id");	
    String s_work =  request.getParameter("work")==null?"A":request.getParameter("work");	
    String s_work_nm =  request.getParameter("work_nm")==null?"A":request.getParameter("work_nm");	
    
   	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	
	
	String st_year 	= request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon 	= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");	
	
	
	String chk="0";
	Vector vts2 = new Vector();
	
	if (!st_year.equals("") &&  !st_mon.equals("") ) {
		vts2 = CardDb.getCardJungDtStatMon(st_year, st_mon, s_user);
	} else {
		vts2 = CardDb.getCardJungDtStatNew(dt, ref_dt1, ref_dt2, s_user);	
	}	
		
	int vt_size2 = vts2.size();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
      
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
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
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	
	//복지비 세부리스트
	function card_list_pop(buy_dt){
		var fm = document.form1;	
		fm.s_buy_dt.value = buy_dt;			
		fm.target = '_blank';			
		fm.action = 'card_jung_sc_in_pop.jsp';					
		fm.submit();
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
 <input type='hidden' name='s_user' 	value='<%=s_user%>'>       
 <input type='hidden' name='s_work' 	value='<%=s_work%>'>       
 <input type='hidden' name='s_work_nm' 	value='<%=s_work_nm%>'>       
 <input type='hidden' name='dt' 		value='<%=dt%>'>       
 <input type='hidden' name='ref_dt1' 	value='<%=ref_dt1%>'>       
 <input type='hidden' name='ref_dt2' 	value='<%=ref_dt2%>'>          
 <input type='hidden' name='st_year' 	value='<%=st_year%>'>       
 <input type='hidden' name='st_mon' 	value='<%=st_mon%>'>          
 <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>           
 <input type='hidden' name='s_buy_dt'	value=''>            
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr> 
  	    <td align='left' colspan=2>&nbsp;&nbsp; <% if( !s_work.equals("A")){%> <img src=/acar/images/center/arrow_sm.gif> : <%=s_work_nm%> &nbsp; &nbsp; <img src=/acar/images/center/arrow_gmis.gif> : <%=s_work%> <%}%></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>

    <tr id='tr_title' >
  
	    <td class='line' width='13%' id='td_title' style='position:relative;'> 

    	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
    
              <tr> 
               <td width='40%' class='title' style='height:45'>연번</td>
                <td width='60%' class='title'>일자</td>
              </tr>
            </table></td>
	    <td class='line' width='88%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
             <tr>
             	<td width="6%"  class="title" rowspan=2 >중식기준액</td>
                <td class="title" colspan=8>항목</td>
                <td width="6%"  class="title" rowspan=2>중식<br>차액</td>
                <td width='6%' class='title' rowspan=2>비고</td>
                          
              </tr>
              <tr>
             	<td width="6%"  class="title">조식</td>
                <td width="6%"  class="title">중식</td>
                <td width="6%"  class="title">특근식</td>
                <td width="6%"  class="title">회식비</td>
                <td width="6%"  class="title">경조사</td>
                <td width="6%"  class="title">팀장활동비</td>
                <td width="6%"  class="title">포상휴가</td>
                <td width="6%"  class="title">합계</td>            
                          
              </tr>
              
            </table>
	    </td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	    <td class='line' width='13%' id='td_con' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	long t_amt1[] = new long[1];
          		long t_amt2[] = new long[1];
            	long t_amt3[] = new long[1];
            	long t_amt4[] = new long[1];
            	long t_amt5[] = new long[1];
            	long t_amt6[] = new long[1];
            	long t_amt7[] = new long[1];
            	long t_amt8[] = new long[1];
            	long t_amt9[] = new long[1];
            	long t_amt10[] = new long[1]; //복지비
            	long t_amt15[] = new long[1]; //복지비
            	long t_amt30[] = new long[1]; //포상휴가
            %>
            <%	for(int i = 0 ; i < vt_size2 ; i++){
    					Hashtable ht = (Hashtable)vts2.elementAt(i);%>
              <tr> 
              	 <td width='40%' align="center"><%= i+1%></td>
                 <td width='60%' align="center"><%=ht.get("JUNG_DT")%></td>
              </tr>
              <%}%>
              <tr> 
                <td class=title align="center" colspan=2>합계</td>
              </tr>		  
            </table></td>
    	<td class='line' width='87%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < vt_size2 ; i++){
    					Hashtable ht = (Hashtable)vts2.elementAt(i);
    					for(int j=0; j<1; j++){
    									
    						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("BASIC_AMT")));
    						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")));
    						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT")));
    						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("REMAIN_AMT")));
    						t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")));
    						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G30_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G4_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));
    						t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")));
    						t_amt9[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")));
    						t_amt10[j] += AddUtil.parseLong(String.valueOf(ht.get("G4_AMT")));
    						t_amt15[j] += AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));
    						t_amt30[j] += AddUtil.parseLong(String.valueOf(ht.get("G30_AMT")));
    					}
    										
    					%>
              <tr> 
    <%          
        long tot = 0;
        tot = AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G30_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")));          
    %>           
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BASIC_AMT")))%></td>
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G2_1_AMT")))%></td>
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("REAL_AMT")))%></td>
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G2_3_AMT")))%></td>
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G2_AMT")))%></td>
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G15_AMT")))%></td>
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G3_AMT")))%></td>
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G30_AMT")))%></td>
                <td width='6%' align="right"><%=Util.parseDecimal(tot)%></td>        
                <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("REMAIN_AMT")))%></td>
                <td width='6%' align="center"><%if(!ht.get("REMARK_DESC").equals("근무일")){%><font color="blue"><%}%><%=ht.get("REMARK_DESC")%><%if(!ht.get("REMARK_DESC").equals("근무일")){%></font><%}%></td>
              </tr>
              <%}%>
              <tr> 
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%></td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt5[0])%></td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt9[0])%></td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt15[0])%></td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt8[0])%></td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt30[0])%></td>
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt7[0])%></td>                         
                <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt4[0])%></td>
                <td class=title align="center"></td>
              </tr>	  
            </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='13%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='87%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>

<% 	}%>
    <tr>
    <td></td>
  </tr>
  <tr>
	  <td colspan=2> 
	    <table border="0" cellspacing="0" cellpadding="0" width='100%'>
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>회식비내역</span></td>
          </tr>
        </table></td>
	
  </tr>
  <tr>
    <td class=line2 colspan=2></td>
  </tr>
  <tr>
  	   <td colspan=2 class='line' width='100%'  style='position:relative;'> 
<%	Vector vts3 = CardDb.getCardJungDtStatG4New(dt, ref_dt1, ref_dt2, s_user);
	int vt_size3 = vts3.size();
	
	if ( vt_size3 % 2 == 1 ) {
		  chk = "1";
	}
%>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    
              <tr> 
                <td width='10%' class='title' style='height:45'>연번</td>
                <td width='20%' class='title'>일자</td>
                <td width='20%' class='title'>금액</td>
                <td width='10%' class='title' style='height:45'>연번</td>
                <td width='20%' class='title'>일자</td>
                <td width='20%' class='title'>금액</td>
              </tr>
            </table></td>	   
  </tr>	
<%	if(vt_size3 > 0){%>
  <tr>
	    <td colspan=2   class='line' width='100%' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%	
            	long t_b_amt = 0;; //복지비
            %>
            <%	for(int j = 0 ; j < vt_size3; j+=2){
    					Hashtable ht1 = (Hashtable)vts3.elementAt(j);
    					t_b_amt += AddUtil.parseLong(String.valueOf(ht1.get("DOC_AMT")));	
    					
    					Hashtable ht2 = new Hashtable();
						if(j+1 < vt_size3){
								ht2 = (Hashtable)vts3.elementAt(j+1);
								t_b_amt += AddUtil.parseLong(String.valueOf(ht2.get("DOC_AMT")));	
						}	
		
   			%>
              <tr> 
              	 <td width='10%' align="center"><%= j+1%></td>
                 <td width='20%' align="center"><a href="javascript:card_list_pop('<%=ht1.get("BUY_DT")%>');"><%=ht1.get("BUY_DT")%></a></td>
                 <td width='20%' align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht1.get("DOC_AMT")))%>원</td>
                 <%if(j+1 < vt_size3) {%>
                 <td width='10%' align="center"><%= j+2%></td>
                 <td width='20%' align="center"><a href="javascript:card_list_pop('<%=ht2.get("BUY_DT")%>');"><%=ht2.get("BUY_DT")%></a></td>
                 <td width='20%' align="right">&nbsp;<%=Util.parseDecimal(String.valueOf(ht2.get("DOC_AMT")))%>원</td>
                 <% } else  { %>	
                 <td width='10%' align="center"></td>
                 <td width='20%' align="center"></td>
                 <td width='20%' align="right">&nbsp;</td>
                 <% } %>
              </tr>
              <%}%>
              <tr> 
                <td class=title align="center" colspan=5>합계</td>
                <td class=title style="text-align:right">&nbsp;<%=Util.parseDecimal(t_b_amt)%>원</td>
              </tr>		
              </table></td>
     </tr>   
 <%	}else{%>                     
  <tr>
	  <td colspan=2  class='line' width='100%'  style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td>등록된 데이타가 없습니다</td>
          </tr>
        </table></td>
  </tr>
<% 	}%>      
  <tr>
    <td></td>
  </tr>
  <tr>
	  <td colspan=2> 
	    <table border="0" cellspacing="0" cellpadding="0" width='100%'>
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정산내역</span></td>
          </tr>
        </table></td>
	
  </tr>
  <tr>
    <td class=line2 colspan=2></td>
  </tr>
   
  <tr>
  	   <td colspan=2 class='line' width='100%'  style='position:relative;'> 
<%	vts2 = JsDb.getCardJungDtStatINew("4", ref_dt1, ref_dt2, "", "", s_user, s_yy);
	int vt_size4 = vts2.size();	
	
	long t_amt1[] = new long[1];
	long t_amt2[] = new long[1];
	long t_amt3[] = new long[1];
	long t_amt4[] = new long[1];
	long t_amt5[] = new long[1];
	long t_amt6[] = new long[1];
	long t_amt7[] = new long[1];
	long t_amt8[] = new long[1];
	long t_amt9[] = new long[1];
	long t_amt10[] = new long[1];
	long t_amt11[] = new long[1];  //budget_amt 
	long t_amt12[] = new long[1];  //g4_amt - 복지비 
	long t_amt13[] = new long[1];  //g_2_4_amt - 정산누계 
	long t_amt15[] = new long[1];  //g_15 - 경조사 
	
    
	
%>
		<table border="0" cellspacing="1" cellpadding="0" width='100%' >

         <tr>
            <td colspan="5"  class="title">설정금액</td>
            <td colspan="3"  class="title">지출금액</td>
            <td width="6%" rowspan=3"  class="title" >팀장활동비</td>
            <td width="7%" rowspan="3"  class="title" ><p>잔액<br>
              (A)-(B)
            </p>
            </td>
          </tr>
         <tr>
           <td width="6%"  rowspan="2" class="title">이월액</td>
           <td width="6%"  rowspan="2" class="title">중식대</td>
           <td width="6%"  colspan="2" class="title">복지비</td>        
           <td width="6%"  rowspan="2" class="title" >소계(A)</td>
           <td width="6%"  rowspan="2" class="title" >중식대</td>
           <td width="6%"  rowspan="2" class="title" >복지비</td>
           <td width="6%"  rowspan="2" class="title" >소계(B)</td>
         </tr>
         <tr>
           <td width="6%"  class="title">일반</td>
           <td width="6%"  class="title">특별</td>        
         </tr>
        </table>
     </td>	   
  </tr>	
<%	if(vt_size4 > 0){%>
  <tr>
	    <td colspan=2   class='line' width='100%' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <% long amt = 0;
          		for(int i = 0 ; i < vt_size4 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					if(ht.get("USER_ID").equals("000003")||ht.get("USER_ID").equals("000004")||ht.get("USER_ID").equals("000005")){
							amt = 0;
					}else{
							amt = AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
					}
					
					for(int j=0; j<1; j++){
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT9"))); //PRV_AMT
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT8"))); //BASIC_AMT
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT4"))); //G4_AMT
						t_amt10[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT5"))); //특별  S_G4_AMT
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT9")))+AddUtil.parseLong(String.valueOf(ht.get("AMT8")))+AddUtil.parseLong(String.valueOf(ht.get("AMT4")));  
						t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1"))); //REAL_AMT
						t_amt6[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT2")));  //G2_AMT
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT1"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));  
						t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT3")));  //G3_AMT 기타 
						t_amt9[j] += ( AddUtil.parseLong(String.valueOf(ht.get("AMT9")))+AddUtil.parseLong(String.valueOf(ht.get("AMT8")))+AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) ) - (amt + AddUtil.parseLong(String.valueOf(ht.get("AMT2"))) );
					}
										
			%>
			<tr>
			 
           <%          
	
			    long tot = 0;
			    tot = AddUtil.parseLong(String.valueOf(ht.get("AMT1")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT3")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT2")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT4")))+ AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));  
			    long s_tot = 0; //설정금액 소계
			    s_tot = AddUtil.parseLong(String.valueOf(ht.get("AMT9")))+AddUtil.parseLong(String.valueOf(ht.get("AMT8")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT4")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT5")));  
			    long c_tot = 0; //지출금액 소계
			    c_tot = amt+ AddUtil.parseLong(String.valueOf(ht.get("AMT2")));  
			    long a_tot = 0; //잔액
			    a_tot = AddUtil.parseLong(String.valueOf(s_tot))- AddUtil.parseLong(String.valueOf(c_tot));  
			    
			    //2017부터
			   	if(ht.get("USER_ID").equals("000003")||ht.get("USER_ID").equals("000004")||ht.get("USER_ID").equals("000005")||ht.get("USER_ID").equals("000026")  ||ht.get("USER_ID").equals("000028")   ||ht.get("USER_ID").equals("000237") ){
			   	  a_tot  =  AddUtil.parseLong(String.valueOf(ht.get("AMT9")))+ AddUtil.parseLong(String.valueOf(ht.get("AMT4"))) + AddUtil.parseLong(String.valueOf(ht.get("AMT5"))) -  AddUtil.parseLong(String.valueOf(ht.get("AMT2")));  
			   	} 
			    
		 %> 
	            <td width='6%' align="right"><%if(dt.equals("5")){%><%}else{%><%=Util.parseDecimal(String.valueOf(ht.get("AMT9")))%><%}%></td>
	            <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT8")))%></td>
	            <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT4")))%></td>
	             <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT5")))%></td>
	            <td width='6%' align="right"><%=Util.parseDecimal(s_tot)%></td>
	            <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT1")))%></td>
	            <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT2")))%></td>
	            <td width='6%' align="right"><%=Util.parseDecimal(c_tot)%></td>
	            <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT3")))%></td>
	            <td width='7%' align="right"><%=Util.parseDecimal(a_tot)%></td>
          </tr>
          <%}%>       
          </table></td>
     </tr>   
<% 	}%>  
                   
  </table>
</form>
</body>
</html>
