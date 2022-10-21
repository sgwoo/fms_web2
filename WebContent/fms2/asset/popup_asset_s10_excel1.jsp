<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_asset_s10_excel1.xls");
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
	Vector vt = as_db.getAssetCarStat1(gubun1, gubun2, gubun, gubun_nm);
	int asset_size = vt.size();		
			
	long t_amt1[] = new long[1];  //기초가액
    long t_amt2[] = new long[1];  //당기 증가
    long t_amt3[] = new long[1];  //충당금 증가
    long t_amt4[] = new long[1];  // 당기 감소
    long t_amt5[] = new long[1];  //충당금 감소
    long t_amt6[] = new long[1];  //전기말 충당금
    long t_amt7[] = new long[1];  //당기말의 장부가액
    long t_amt8[] = new long[1]; //상각액
    long t_amt9[] = new long[1]; 
    long t_amt10[] = new long[1]; //매각액  
    long t_amt11[] = new long[1]; //구매보조금  
    long t_amt12[] = new long[1]; //전기말 구매보조금  
    long t_amt13[] = new long[1]; //당기말 구매보조금  
    long t_amt14[] = new long[1]; //구매보조금 감소 
    long t_amt15[] = new long[1]; //구매보조금 증가 
    long t_amt16[] = new long[1]; //매각액 
  	 
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="../../include/common.js"></script>
</head>

<body leftmargin="15">

<table border="1" cellspacing="0" cellpadding="0" width='1800'>
<tr><td class=line2 colspan=2></td></tr>
  <tr id='tr_title' style='position:relative;z-index:1' >		
    <td class='line' width='23%' id='td_title' style='position:relative;' > 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%' height=43>
        <tr> 
          <td width='7%' class='title'>연번</td>
          <td width='12%' class='title'>자산코드</td>
          <td width='28%' class='title'>자산명</td>
          <td width='18%' class='title'>차량번호</td>
          <td width="15%" class='title'>취득일자</td>    
        </tr>
      </table>
	</td>
	<td class='line' width='77%' >
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
	  	  <td width="7%" class='title'>기초가액</td>
		  <td width="7%" class='title'>전기말충당금</td>	
		  <td width="6%" class='title'>전기말보조금</td>	
		  <td width="7%" class='title'>당기증가</td>	
		  <td width="6%" class='title'>보조금증가</td>	
		  <td width="6%" class='title'>충당금증가</td>			  
	      <td width='6%' class='title'>당기감소</td>
	      <td width='6%' class='title'>충당금감소</td>
	      <td width='5%' class='title'>보조금감소</td>
	      <td width="7%" class='title'>일반상각액</td>		
	      <td width="6%" class='title'>구매보조금</td>		
	      <td width="7%" class='title'>당기말충당금</td>		 
	      <td width="6%" class='title'>당기말보조금</td>		 
	      <td width="7%" class='title'>당기말장부가액</td>	
	      <td width="5%" class='title'>매각일</td>	
	      <td width="6%" class='title'>매각금액</td>	   	  
		</tr>
	  </table>
	</td>
  </tr>
   <%if(asset_size > 0){%>
  <tr>		
    <td class='line' width='23%' id='td_con' style='position:relative;'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < asset_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
				
        <tr> 
          <td width='7%' align='center'><%=i+1%></td>
          <td width='12%' align='center'><%=ht.get("ASSET_CODE")%></td>
          <td width='28%' align='center'><span title='<%=String.valueOf(ht.get("ASSET_NAME"))%>'><%=Util.subData(String.valueOf(ht.get("ASSET_NAME")), 12)%></span></td>
          <td width='18%' align='center'><%=ht.get("CAR_NO")%></td>		
          <td width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>    
        </tr>
        <%		}	%>
        <tr> 
            <td class=title colspan="5" align="center">합계</td>
         </tr>
      </table>
	</td>
	<td class='line' width='77%'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < asset_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
					
				long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;
				long t5=0;
				long t6=0;
				long t7=0;
				long t8=0;
				long t9=0;
				long t10=0;  //매각액  
				long t11=0;  //구매보조금상각액 
				long t12=0;  //전기말 구매보조금 
				long t13=0;  //당기말 구매보조금 
				long t14=0;  //구매보조금감소 
				long t15=0;  //구매보조금증가 	
				long t16=0;  //매각액 	
												
				
				t1=AddUtil.parseLong(String.valueOf(ht.get("T1")));
				t2=AddUtil.parseLong(String.valueOf(ht.get("T2")));
				t3=AddUtil.parseLong(String.valueOf(ht.get("T3")));
				t4=AddUtil.parseLong(String.valueOf(ht.get("T4")));
				t5=AddUtil.parseLong(String.valueOf(ht.get("T5")));
				t6=AddUtil.parseLong(String.valueOf(ht.get("T6")));
				t7=AddUtil.parseLong(String.valueOf(ht.get("T7")));
				t8=AddUtil.parseLong(String.valueOf(ht.get("T8")));
				t9=AddUtil.parseLong(String.valueOf(ht.get("T9")));
				t10=AddUtil.parseLong(String.valueOf(ht.get("T10")));
				t11=AddUtil.parseLong(String.valueOf(ht.get("T11")));
				t12=AddUtil.parseLong(String.valueOf(ht.get("T12")));
				t13=AddUtil.parseLong(String.valueOf(ht.get("T13")));
				t14=AddUtil.parseLong(String.valueOf(ht.get("T14")));
				t15=AddUtil.parseLong(String.valueOf(ht.get("T15")));
				t16=AddUtil.parseLong(String.valueOf(ht.get("SALE_AMT")));
				
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
						t_amt11[j] += t11;
						t_amt12[j] += t12;
						t_amt13[j] += t13;
						t_amt14[j] += t14;
						t_amt15[j] += t15;		
						t_amt16[j] += t16;		
				}
				
		%>
		<tr>
		  <td width="7%" align='right'><%=Util.parseDecimal(t1)%></td> <!-- 기초가액 -->
		  <td width="7%" align='right'><%=Util.parseDecimal(t6)%></td>	<!-- 전기말 충당금 -->	
		  <td width="6%" align='right'><%=Util.parseDecimal(t12)%></td> <!--전기말 구매보조금 -->		
		  <td width="7%" align='right'><%=Util.parseDecimal(t2)%></td>	<!-- 당기증가 -->		
		  <td width="6%" align='right'><%=Util.parseDecimal(t15)%></td>	<!-- 보증금증가 -->				
		  <td width="6%" align='right'><%=Util.parseDecimal(t3)%></td>  <!-- 당기 충당금 증가 -->
		  <td width="6%" align='right'><%=Util.parseDecimal(t4)%></td>   <!--당기 감소 -->
		  <td width='6%' align='right'><%=Util.parseDecimal(t5)%></td>   <!-- 당기 충당금 감소 -->
		  <td width='5%' align='right'><%=Util.parseDecimal(t14)%></td>   <!-- 당기 보조금 감소 -->
		  <td width='7%' align='right'><%=Util.parseDecimal(t8)%></td>	<!-- 일반상각액 -->
		  <td width='6%' align='right'><%=Util.parseDecimal(t11)%></td>  <!-- 구매보조금 -->
		  <td width='7%' align='right'><%=Util.parseDecimal(t9)%></td>	 <!-- 당기말 충당금 -->
		  <td width='6%' align='right'><%=Util.parseDecimal(t13)%></td>	 <!--당기말 구매보조금  -->
		  <td width='7%' align='right'><%=Util.parseDecimal(t7)%></td>  <!-- 장부가액 -->	
		  <td width='5%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SALE_DATE")))%></td>  <!-- 매각일  -->		
		  <td width='6%' align='right'><%=Util.parseDecimal(t16)%></td>  <!-- 매갹액 -->	
			
		</tr>
<%		}	%>
		<tr>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt1[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt6[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt12[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt2[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt15[0])%></td>	 		  			
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt3[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt4[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt5[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt14[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt8[0])%></td>		 
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt11[0])%></td>		 
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt9[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt13[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt7[0])%></td>		
		  <td class=title style='text-align:right;'></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt16[0])%></td>		
		</tr>
	  </table>
	</td>
<%	}else{	%>                     
  <tr>		
    <td class='line' width='23%' id='td_con' style='position:relative;'> 
	  <table border="1" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td align='center'>등록된 데이타가 없습니다</td>
        </tr>
      </table>
	</td>
	<td class='line' width='77%'>			
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


