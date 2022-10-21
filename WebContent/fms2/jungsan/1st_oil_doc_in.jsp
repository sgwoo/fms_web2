<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	String user_nm	= request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");	
	String st_year		= request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	String s_gubun3 =  request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	int year =AddUtil.getDate2(1);
	
	float t_amt1[] = new float[2];
	long t_amt2[] = new long[2];
	float t_amt3[] = new float[2];
	float t_amt4[] = new float[2];
	
	int vt_size2 = 0;
	Vector vts2 = new Vector();
	vts2 = JsDb.getCardJungDtStatONew_1st(dt, st_year, ref_dt1, ref_dt2, br_id, dept_id, user_id, s_gubun3);
	vt_size2 = vts2.size();
	
	long s_tot = 0; //설정금액 소계
	long c_tot = 0; //지출금액 소계
	long a_tot = 0; //잔액
	
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
	<input type='hidden' name='user_id' value='<%=user_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr>
        <td class=line2></td>
    </tr>
   <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='30%' id='td_title' style='position:relative;'> 

	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>

          <tr>       
            <td width="25%" class="title" style='height:45'>귀속월</td>
             <td width="30%" class="title">차량번호</td>
            <td width="45%" class="title">차종</td>
          </tr>
        </table></td>
	<td class='line' width='70%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >

         <tr>
            <td colspan="3"  class="title">주유현황</td>
            <td colspan="3"  class="title">주행거리</td>
            <td rowspan="2"  class="title" width="12%">평균연비</td>
            <td rowspan="2"  class="title" width="12%">평균<br>주유단가</td>
          </tr>
         <tr>
           <td width="14%"  class="title">유종</td>
           <td width="10%"  class="title">주유량</td>
           <td width="16%"  class="title">지불금액</td>
           <td width="12%"  class="title" >전월누적거리</td>
           <td width="12%"  class="title" >현재누적거리</td>
           <td width="12%"  class="title" >실제주행거리</td>
                 </tr>
        </table>
	</td>
  </tr>	
  
  <%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='30%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	     <%	String row_chk = "";
        	     		int row_cnt = 0;
        	     		int p_row_cnt = 0;
        	     		String p_mm = "";
        	     		        	     		
        	     		for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);		
				
				row_cnt =  AddUtil.parseInt(String.valueOf(ht.get("ROW_CNT")));		
				
				if ( row_cnt == p_row_cnt   &&  String.valueOf(ht.get("MM")).equals(p_mm)   ) {
					row_chk = "Y";
				}
				
         %>			      
          <tr> 
            <% if ( row_cnt  == 1 )  {%>              
               <td width="25%" align="center"><%=Util.parseDecimal(String.valueOf(ht.get("MM")))%>월</td>    
            <%  } else   if  (   row_chk.equals("")    )   {%>
          	 <td width="25%" align="center" rowspan=<%=row_cnt%>><%=Util.parseDecimal(String.valueOf(ht.get("MM")))%>월</td>                 	
            <%  } %> 
       
             <td width="30%" align="center"><%=ht.get("CAR_NO")%></td>
             <td width="45%" align="center"><%=ht.get("CAR_NM")%></td>    
          </tr>
        <%
             p_row_cnt = 	AddUtil.parseInt(String.valueOf(ht.get("ROW_CNT")));	
             p_mm = 	String.valueOf(ht.get("MM"));		
             row_chk = "";             			
        }               
        %>  
          <tr> 
            <td class=title colspan="3" align="center">합계</td>
          </tr>		  
        </table></td>
	<td class='line' width='70%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%
          					
          for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					for(int j=0; j<1; j++){
				
						t_amt1[j] += AddUtil.parseFloat(String.valueOf(ht.get("OIL_LITER")));
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
						
						t_amt3[j] +=AddUtil.parseFloat(String.valueOf(ht.get("AVE_DIST"))) ;
						t_amt4[j] +=AddUtil.parseFloat(String.valueOf(ht.get("AVE_AMT"))) ;
											
					}
										
					%>
          <tr> 
<%          
  
//    float   f_oil_ave_amt =  AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(ht.get("OIL_AVE_AMT"))) ,1);

    float   f_ave_dist=  AddUtil.parseFloat(String.valueOf(ht.get("AVE_DIST"))) ;
    float   f_ave_amt =  AddUtil.parseFloat(String.valueOf(ht.get("AVE_AMT"))) ;
    
%> 
            <td width='14%' align="center"><%=ht.get("FUEL_KD")%></td>
            <td width='10%' align="right"><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht.get("OIL_LITER"))),2)%></td>
            <td width='16%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>
            <td width='12%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("P_TOT_DIST")))%></td> <!--전월누적거리-->
            <td width='12%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%></td>  <!--현재누적거리 -->
            <td width='12%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("R_TOT_DIST")))%></td> <!--실주행거리-->
            <td width='12%' align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseDecimal(f_ave_dist ),1)%></td>   <!--평균연비주행거리 -->  
            <td width='12%' align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseDecimal(f_ave_amt ),1)%></td>  <!--평균주유단가금액 -->
      
          </tr>
          <%}%>
          <tr> 
            	<td class='title' ><div align="right"></div></td>
		<td class='title' ><div align="right"><%=Util.parseDecimal(t_amt1[0])%></div></td>
		<td class='title' ><div align="right"><%=Util.parseDecimal(t_amt2[0])%></div></td>
		<td class='title' ><div align="right"></div></td>
		<td class='title' ><div align="right"></div></td>
		<td class='title' ><div align="right"></div></td>
		<td class='title' ><div align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseDecimal(t_amt3[0] ),1)%></div></td>
		<td class='title' ><div align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseDecimal(t_amt4[0] ),1)%></div></td>
					
          </tr>	  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='30%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='70%'>
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