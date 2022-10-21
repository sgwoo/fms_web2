<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	

	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	
	
	long g_j_jan = 0;       

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

<script language='javascript'>
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
	
			
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//-->	
</script>
</head>

<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
<table border="0" cellspacing="0" cellpadding="0" width="1440">
<tr><td class=line2 colspan="2"></td></tr>
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='23%' id='td_title' style='position:relative;'> 
<%	
	int vt_size2 = 0;
	
	Vector vts2 = CardDb.getCardJungDtStatINew(dt, ref_dt1, ref_dt2, br_id, dept_id, user_nm);
	vt_size2 = vts2.size();
	
%>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>

          <tr> 
            <td width="15%"  class="title" style='height:45'>연번</td>
            <td width="29%" class="title">부서</td>
            <td width="26%" class="title">직급</td>
            <td width="30%" class="title">성명</td>
          </tr>
        </table></td>
	<td class='line' width='77%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >

         <tr>
            <td  class="title" rowspan=2 width="4%">근무<br>일수</td>
            <td  class="title" rowspan=2 width="7%">중식<br>기준액</td>
            <td  class="title" rowspan=2 width="7%">복지비<br>기준액</td>
            <td  class="title" colspan=8 >항목</td>
            <td  class="title" rowspan=2 width='7%' >중식<br>누계금액</td>
            <td  class="title" rowspan=2 width='8%' >복지비<br>누계금액</td>
            <td  class="title" rowspan=2 width='8%' >정산차액</td>         
          </tr>
           <tr>
            <td width="5%"  class="title">조식</td>
            <td width="7%"  class="title">중식</td>
            <td width="5%"  class="title">특근식</td>
            <td width="6%"  class="title">복지비</td>
            <td width="5%"  class="title">경조사</td>
            <td width="5%"  class="title">기타</td>
            <td width="5%"  class="title">포상휴가</td>
            <td width="8%"  class="title">합계</td>
           
          </tr>
        </table>
	</td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='23%' id='td_con' style='position:relative;'> 
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
        	long t_amt10[] = new long[1];
        	long t_amt11[] = new long[1];  //budget_amt 
        	long t_amt12[] = new long[1];  //g4_amt - 복지비 
        	long t_amt13[] = new long[1];  //g_2_4_amt - 정산누계 
       		long t_amt15[] = new long[1];  //g_15 - 경조사 
       		long t_amt14[] = new long[1];  //t_basic_amt - 중식기준액 
       		
       		long t_amt30[] = new long[1];  //g30_amt - 포상휴가 
       		
        
        	String nn= "";
        %>
        
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					if (ht.get("USER_ID").equals("000000")) {
            		   nn = "아르바이트";
        			} else {     
           			   nn =(String) ht.get("DEPT_NM");
            
           			} 
         %>			
          <tr> 
          	<td width="15%" align="center"><%= i + 1 %></td>
            <td width="29%" align="center"><%=nn%></td>
            <td width="26%" align="center"><%=ht.get("USER_POS")%></td>
            <td width="30%" align="center"><%=ht.get("USER_NM")%>
            <a href="javascript:MM_openBrWindow('card_jung_sc_in.jsp?work_nm=<%=ht.get("USER_NM")%>&work=<%=ht.get("W_CNT")%>&dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&auth_rw=1&user_id=<%= ht.get("USER_ID") %>&br_id=<%= ht.get("BR_ID") %>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=960,height=700,top=20,left=20')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="리스트보기"></a></td>
                
          </tr>
          <%}%>
          <tr> 
            <td class=title colspan="5" align="center">합계</td>
          </tr>		  
        </table></td>
	<td class='line' width='77%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					for(int j=0; j<1; j++){
				
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("BASIC_AMT")));
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")));
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT")));
						t_amt4[j] += AddUtil.parseLong(String.valueOf(ht.get("T_REAL_AMT")));
						t_amt5[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")));
						t_amt7[j] += AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G4_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));
						t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")));
						t_amt9[j] += AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")));
						t_amt10[j] += AddUtil.parseLong(AddUtil.sl_th_rnd(String.valueOf(ht.get("REMAIN_AMT"))));
						t_amt11[j] += AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
						t_amt12[j] += AddUtil.parseLong(String.valueOf(ht.get("G4_AMT")));
						t_amt13[j] += AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
						t_amt15[j] += AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));
						t_amt14[j] += AddUtil.parseLong(String.valueOf(ht.get("T_BASIC_AMT")));  
						t_amt30[j] += AddUtil.parseLong(String.valueOf(ht.get("G30_AMT")));  
					
						
					}
										
					%>
          <tr> 
<%          
    long tot = 0;
    tot = AddUtil.parseLong(String.valueOf(ht.get("REAL_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_1_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G2_3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G3_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G2_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G30_AMT"))) + AddUtil.parseLong(String.valueOf(ht.get("G4_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("G15_AMT")));  
    
    long b_tot = 0;
    b_tot = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));  
    
    long j_tot=0;
    j_tot = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT")))- AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
    
    long j_jan=0;
    
    if (ht.get("USER_ID").equals("000003") || ht.get("USER_ID").equals("000004") || ht.get("USER_ID").equals("000005")  || ht.get("USER_ID").equals("000237")   ) {
        j_jan = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT")))  -  AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
    } else {
         j_jan = AddUtil.parseLong(String.valueOf(ht.get("BUDGET_AMT"))) +  AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT"))) +  AddUtil.parseLong(String.valueOf(ht.get("T_BASIC_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("T_REAL_AMT"))) -  AddUtil.parseLong(String.valueOf(ht.get("G_2_4_AMT")));
    } 
        	     
    g_j_jan += j_jan;     
    
      
        
%> 
            <td width='4%' align="center"><%=Util.parseDecimal(String.valueOf(ht.get("W_CNT")))%></td>
            <td width='7%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BASIC_AMT")))%></td>
            <td width='7%' align="right"><%=Util.parseDecimal(b_tot)%></td>
            <td width='5%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G2_1_AMT")))%></td>
            <td width='7%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("REAL_AMT")))%></td>
            <td width='5%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G2_3_AMT")))%></td>
            <td width='6%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G2_AMT")))%></td>
            <td width='5%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G15_AMT")))%></td>
            <td width='5%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G3_AMT")))%></td>
            <td width='5%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G30_AMT")))%></td>
            <td width='8%' align="right"><%=Util.parseDecimal(tot)%></td>
            <td width='7%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("T_REAL_AMT")))%></td>            
            <td width='8%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("G_2_4_AMT")))%></td>            
            <td width='8%' align="right"><%=Util.parseDecimal(j_jan)%></td> 
          </tr>
          <%}%>
          <tr> 
            <td class=title align="center"> &nbsp;</td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt11[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt2[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt5[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt9[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt15[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt8[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt30[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt7[0])%></td>
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt4[0])%></td>      <!--중식누계 -->   
            <td class=title style="text-align:right"><%=Util.parseDecimal(t_amt13[0])%></td>       <!--북지비누계 -->   
            <td class=title style="text-align:right"><%=Util.parseDecimal(g_j_jan)%></td>      <!--정산차액누계 -->    
           </tr>	  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='23%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='77%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
  </table>
</form>
</body>
</html>
