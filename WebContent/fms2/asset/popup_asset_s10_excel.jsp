<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_asset_s10_excel.xls");
%>

<%@ page import="java.util.*, acar.asset.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
			
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"L":request.getParameter("gubun2");    //구분: L:lease, R:rent
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"0":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	 
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	AssetDatabase as_db = AssetDatabase.getInstance();
	
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
       
    long t_amt10[] = new long[1];   //매각처분원가    
    long t_p_amt6[] = new long[1];  
    long t_m_amt6[] = new long[1];   
  	 
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="../../include/common.js"></script>
</head>

<body leftmargin="15">

<table border="1" cellspacing="0" cellpadding="0" width='1700'>
<tr><td class=line2 colspan=2></td></tr>
  <tr id='tr_title' style='position:relative;z-index:1' >		
    <td class='line' width='32%' id='td_title' style='position:relative;' > 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%' height=43>
        <tr> 
          <td width='7%' class='title' >연번</td>
          <td width='14%' class='title'>자산코드</td>
          <td width='34%' class='title'>자산명</td> 
          <td width="15%" class='title'>취득일자</td>
          <td width="15%" class='title'>매각일자</td>      
        </tr>
      </table>
	</td>
	<td class='line' width='68%' >
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		  <td width="9%" class='title'>취득가액</td>
		  <td width="9%" class='title'>전기말충담금</td>		
		  <td width="9%" class='title'>전기말보조금</td>		
		  <td width="9%" class='title'>일반상각액</td>		
		  <td width="9%" class='title'>구매보조금 </td>		
	     <td width="9%" class='title'>당기말충담금</td>	
	        <td width="10%" class='title'>보조금잔액(매각)</td>	
	     <td width="9%" class='title'>당기말보조금</td>	 
		  <td width="9%" class='title'>당기말장부가액</td>
		  <td width="9%" class='title'>매각액</td>	     			   	
		  <td width="9%" class='title'>손익</td>	     			   	  
		</tr>
	  </table>
	</td>
  </tr>
   <%if(asset_size > 0){%>
  <tr>		
    <td class='line' width='32%' id='td_con' style='position:relative;'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < asset_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
				
        <tr> 
          <td  width='7%' align='center' ><%=i+1%></td>
          <td  width='14%' align='center'><%=ht.get("ASSET_CODE")%></td>
          <td  width='34%' align='center'><span title='<%=String.valueOf(ht.get("ASSET_NAME"))%>'><%=Util.subData(String.valueOf(ht.get("ASSET_NAME")), 16)%></span></td>
          <td  width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>
          <td  width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SALE_DATE")))%></td>
        </tr>
        <%		}	%>
        <tr> 
            <td class=title colspan="5" align="center">합계</td>
         </tr>
      </table>
	</td>
	<td class='line' width='68%'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
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
							
						if ( t6 >=0 ) {
							t_p_amt6[j] += t6;
						} else {
							t_m_amt6[j] += t6;
						}
									
				}
				
		%>
		<tr>
		  <td  width='9%' align='right' ><%=Util.parseDecimal(t1)%></td> 
		  <td  width='9%' align='right'><%=Util.parseDecimal(t8)%></td>		 
		  <td  width='9%' align='right'><%=Util.parseDecimal(t11)%></td>		
		  <td  width='9%' align='right'><%=Util.parseDecimal(t2)%></td>		
		  <td  width='9%' align='right'><%=Util.parseDecimal(t12)%></td>		 <!--구매보조금 -->
		  <td  width='9%' align='right'><%=Util.parseDecimal(t7)%></td>	<!--당기말 충당금 -->
		  <td  width='10%' align='right'><%=Util.parseDecimal(t14)%></td>	<!- 구매보조금 잔액(매각) -->
		  <td  width='9%' align='right'><%=Util.parseDecimal(t9)%></td>	<!-- 당기말 구매보조금 -->			
		  <td  width='9%' align='right'><%=Util.parseDecimal(t4)%></td>  <!--장부가액 -->	
		  <td  width='9%' align='right'><%=Util.parseDecimal(t5)%></td>  <!--매각액 -->
		  <td  width='9%' align='right'><%=Util.parseDecimal(t6)%></td>  <!--손익 -->
			
		</tr>
<%		}	%>
		<tr>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt1[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt8[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt11[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt2[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt12[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt7[0])%></td>	
		    <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt14[0])%></td>	
		   <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt9[0])%></td>				
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt4[0])%></td>
		    <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt5[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt6[0])%></td>	
		</tr>
	  </table>
	</td>
<%	}else{	%>                     
  <tr>		
    <td class='line' width='32%' id='td_con' style='position:relative;'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td align='center'>등록된 데이타가 없습니다</td>
        </tr>
      </table>
	</td>
	<td class='line' width='68%'>			
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


