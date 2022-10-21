<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_asset_s5_excel.xls");
%>

<%@ page import="java.util.*, acar.common.*, acar.asset.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>

<%
			
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"0":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");

	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AssetDatabase a_db = AssetDatabase.getInstance();
	
	Vector vt = new Vector();
	
	vt = a_db.getAssetSaleList(chk1, st_dt,end_dt,s_kd, s_au, t_wd, sort, asc, gubun, gubun_nm);

	int cont_size = vt.size();
	
	long t_amt1[] = new long[1];  //기초가액
    long t_amt2[] = new long[1];  //당기 증가
    long t_amt3[] = new long[1];  //충당금 증가
    long t_amt4[] = new long[1];  // 당기 감소
    long t_amt5[] = new long[1];  //충당금 감소
    long t_amt6[] = new long[1];  //전기말 충당금
    long t_amt7[] = new long[1];  //당기말의 장부가액
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    long t_amt10[] = new long[1];
    long t_amt11[] = new long[1];
    long t_amt12[] = new long[1];   //구매보조금 
  	 
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="../../include/common.js"></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="1" cellspacing="0" cellpadding="0" width='1520'>
<tr><td class=line2 colspan=2></td></tr>
  <tr id='tr_title' style='position:relative;z-index:1' >		
    <td class='line' width='620' id='td_title' style='position:relative;' > 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%' height=43>
        <tr> 
          <td width='30' class='title'>연번</td>
          <td width='60' class='title'>자산코드</td>
          <td width='200' class='title'>자산명</td>
          <td width='90' class='title'>차량번호</td>
          <td width="70" class='title'>취득일자</td>
          <td width="70" class='title'>매각일자</td>
          <td width="100" class='title'>경매장</td>
        </tr>
      </table>
	</td>
	<td class='line' width='900' >
	  <table border="1" cellspacing="1" cellpadding="0" width='100%' height=43>
		<tr>
		  <td width="100" class='title'>매각액</td>			  
	      <td width='100' class='title'>손익</td>
		  <td width="100" class='title'>기초가액</td>
		  <td width="100" class='title'>상각누계액</td>	
		  <td width="100" class='title'>구매보조금</td>	
		  <td width="100" class='title'>장부가액</td>	
		  <td width="80" class='title'>주행거리</td>
		  <td width="100" class='title'>연료</td>	
		  <td width="70" class='title'>사고유무</td>	
		  <td width="50" class='title'>차령</td>			  
		</tr>
	  </table>
	</td>
  </tr>
  <%if(cont_size > 0){%>
  <tr>		
    <td class='line' width='620' id='td_con' style='position:relative;'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(!String.valueOf(ht.get("DEPRF_YN")).equals("2")) td_color = "class='is'";%>
        <tr> 
          <td <%=td_color%> width='30' align='center'><%=i+1%></td>
          <td <%=td_color%> width='60' align='center'><%=ht.get("ASSET_CODE")%></td>
          <td <%=td_color%> width='200' align='center'><%=Util.subData(String.valueOf(ht.get("ASSET_NAME")), 17)%></td>
          <td <%=td_color%> width='90' align='center'><%=ht.get("CAR_NO")%></td>		
          <td <%=td_color%> width='70' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>
          <td <%=td_color%> width='70' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ASSCH_DATE")))%></td>
          <td <%=td_color%> width='100' align='center'>
          <% if (String.valueOf(ht.get("ASSCH_RMK")).equals("폐차") || String.valueOf(ht.get("ASSCH_RMK")).equals("폐기")) { %>폐차
          <% } else if (String.valueOf(ht.get("ACTN_ID")).equals("") && String.valueOf(ht.get("ASSCH_RMK")).equals("매입옵션") ) { %>매입옵션
          <% } else if (String.valueOf(ht.get("ACTN_ID")).equals("") && String.valueOf(ht.get("ASSCH_RMK")).equals("매각")) { %>매각          
          <% } else { %><%=AddUtil.subData(olaD.getActn_nm(String.valueOf(ht.get("ACTN_ID"))),7)%></td>
          <% } %>    
        </tr>
        <%		}	%>
        <tr> 
            <td class=title colspan="7" align="center">합계</td>
         </tr>
      </table>
	</td>
	<td class='line' width='900'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String td_color = "";
				if(!String.valueOf(ht.get("DEPRF_YN")).equals("2")) td_color = "class='is'";
				
							
				long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;
				long t5=0;
				long t6=0;
				long t7=0;
				long t8=0;
				long t9=0;
				long s1=0; //매각액
				float f_sup_amt = 0;
				long sup_amt = 0;
				
				long t12=0;   //구매보조금 
												
				if (String.valueOf(ht.get("GET_DATE")).substring(0,4).equals(String.valueOf(ht.get("GISU")))) {
				  t1 = 0;
				  t2 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")))+ AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
              	} else {
                  t1 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")));
                  t2 = AddUtil.parseLong(String.valueOf(ht.get("BOOK_DR")));
              	} 
				
								
				t4=AddUtil.parseLong(String.valueOf(ht.get("BOOK_CR")));
				t6=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")));
				t8=AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
				t12=AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT")));
				
				if ( ht.get("DEPRF_YN").equals("5")) {
					t5=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")))+ AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
					t7 = 0;
					t9 = 0;
				} else {
					t7 = t1 + t2 - t6 - t8;
					t9 = t6 + t8;
				}
				
				s1=AddUtil.parseLong(String.valueOf(ht.get("SALE_AMT")));
				
			//	f_sup_amt = AddUtil.parseFloat(String.valueOf(ht.get("SALE_AMT")))  /  AddUtil.parseFloat("1.1") ; //과세표준
				
				if (String.valueOf(ht.get("ASSCH_RMK")).equals("폐차") || String.valueOf(ht.get("ASSCH_RMK")).equals("폐기") ) {
					if ( !String.valueOf(ht.get("CLIENT_ID2")).equals("99")  ) {
							sup_amt=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
					} else {					
							sup_amt = s1;
					}				
				} else {
					sup_amt=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
				}
				
			//	if (String.valueOf(ht.get("ASSCH_RMK")).equals("폐차") || String.valueOf(ht.get("ASSCH_RMK")).equals("폐기") ) {
			//		sup_amt = s1;
			//	} else {
			//		sup_amt=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
			//	}
				
	  		//	sup_amt= (int) f_sup_amt;
	   		//	vat_amt = su_bean.getSale_amt() -  sup_amt;	//부가세	
	      		
				for(int j=0; j<1; j++){
				
						t_amt1[j] += t1;
						t_amt2[j] += t2;
						t_amt3[j] += t3;
						t_amt4[j] += t4;
						t_amt5[j] += t5;
						t_amt6[j] += t6;
						t_amt7[j] += t7;
						t_amt8[j] += t8;
						t_amt9[j] += t9;
						t_amt12[j] += t12;
						t_amt10[j] += s1;
						t_amt11[j] += sup_amt;
														
				}
						
		%>
		<tr>
		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(sup_amt)%></td>
		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(sup_amt - (t1 + t2 - t6 - t8 - t12) )%></td>
		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(t1+t2)%></td>
		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(t6+ t8)%></td>	
		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(t12)%> </td>	<!-- 구매보조금-->	
		  <td <%=td_color%> width='100' align='right'><%=Util.parseDecimal(t1 + t2 - t6 - t8 - t12 )%></td>					
		  <td <%=td_color%> width='80' align='right'>
		    <%=AddUtil.parseDecimal(String.valueOf(ht.get("KM")))%>km
		  </td>
		  <td <%=td_color%> width='100' align='center'>
		     <%=c_db.getNameByIdCode("0039", "", String.valueOf(ht.get("FUEL_KD")))%>
		  </td>		
		  <td <%=td_color%> width='70' align='center'>
		    					<%if(String.valueOf(ht.get("ACCIDENT_YN")).equals("1")){%>
                                유 
                                <%}else{%>
                                - 
                                <%}%>
		  </td>					
        		  <td <%=td_color%> width='50' align='right'><%=ht.get("USE_MON")%></td>						
		</tr>
<%		}	%>
		<tr>
		  <td  class=title  style="text-align:right"><%=Util.parseDecimal(t_amt11[0])%></td>
		  <td  class=title  style="text-align:right"><%=Util.parseDecimal(t_amt11[0] - (t_amt1[0] + t_amt2[0] - t_amt6[0] - t_amt8[0]- t_amt12[0]))%></td>
		  <td  class=title  style="text-align:right"><%=Util.parseDecimal(t_amt1[0]+ t_amt2[0])%></td>
		  <td  class=title  style="text-align:right"><%=Util.parseDecimal(t_amt6[0] + t_amt8[0])%></td>	
		  <td  class=title  style="text-align:right"><%=Util.parseDecimal(t_amt12[0])%></td>	 
		  <td  class=title  style="text-align:right"><%=Util.parseDecimal(t_amt1[0] + t_amt2[0] - t_amt6[0] - t_amt8[0] - t_amt12[0] )%></td>					
		  <td class=title colspan='4'>&nbsp;</td>
		</tr>
	  </table>
	</td>
<%	}else{	%>                     
  <tr>		
    <td class='line' width='620' id='td_con' style='position:relative;'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td align='center'>등록된 데이타가 없습니다</td>
        </tr>
      </table>
	</td>
	<td class='line' width='900'>			
      <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
		  <td>&nbsp;</td>
		</tr>
  	  </table>
	</td>
  </tr>
<%	}	%>
</table>

</body>
</html>


