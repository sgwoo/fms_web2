<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cost.*"%>

<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //년도
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2"); //항목
		
	// gubun2 : 1:채권 
	Vector vt = ac_db.getStatCmpList2(gubun1, gubun2);
		
	int vt_size =vt.size();
	
	float t_amt1[] = new float[2];   
    	float t_amt2[] = new float[2];   
    	float t_amt3[] = new float[2];   
    	float t_amt4[] = new float[2];   
    	float t_amt5[] = new float[2];   
   	float ave_per[] = new float[2];   
    
      
    	float ct_amt1[] = new float[2];
    	float ct_amt2[] = new float[2];  
    	float ct_amt3[] = new float[2];  
    	float ct_amt4[] = new float[2];  
    	float ct_amt5[] = new float[2];  
    
    String loan_chk = "";
    int    loan_cnt = 1;
    int    t_loan_cnt = 1;
    
    int tp_amt0 = 0;
    int tp_amt1 = 0;
    int tp_amt2 = 0;
    int tp_amt3 = 0;      
    
    String dept_nm = "";
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
<script language='javascript'>

</script>
</head>
<body  onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
  
    <tr> 
    <td colspan="2" align="left"><font face="굴림" size="2" > 
      <b>&nbsp; * &nbsp <%= gubun1%>년&nbsp;   채권캠페인 </b> </font></td>
  </tr>  
    
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                   <td rowspan=2 width="2%" class='title' >순번</td>
                    <td rowspan=2 width="10%" class='title' >구분</td>
                    <td rowspan=2 width="7%" class='title'>성명</td>
                    <td rowspan=2 width="7%" class='title'>입사일</td>             
        	        <td colspan=3 class=title>1</td>
                    <td colspan=3 class=title>2</td>
                    <td colspan=3 class=title>3</td>
                    <td colspan=3 class=title>4</td>
                     <td colspan=2 class=title  width="14%"  >적용합계 </td>   
               </tr>      
               <tr>     
                    <td class=title>평균 </td>
                    <td class=title>증감 </td>
                    <td class=title>적용 </td>
                    <td class=title>평균 </td>
                    <td class=title>증감 </td>
                    <td class=title>적용 </td>
                    <td class=title>평균 </td>
                    <td class=title>증감 </td>
                    <td class=title>적용 </td>
                    <td class=title>평균 </td>
                    <td class=title>증감 </td>
                    <td class=title>적용 </td>                                 
                     <td class=title width="7%">계 </td>        
                     <td class=title>평균 </td>    
                </tr>           
            </table>
		</td>
	</tr>
	
  
<%if(vt_size > 0){%>
    <tr>		
        <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				if ( i == 0 ) {
				    loan_chk = String.valueOf(ht.get("LOAN_ST"));
				}		
											
				//명칭
				dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));
						
				float t1=0;
				float t2=0;
				float t3=0;
				float t4=0;
				float t5=0; //계
				float t_ave_per = 0;
				
				float ct1=0;
				float ct2=0;
				float ct3=0;
				float ct4=0;
			
				// gubun2 : 1:채권 	
			
				t1=AddUtil.parseFloat(String.valueOf(ht.get("D1"))); //채권캠폐인(1)				
				t2=AddUtil.parseFloat(String.valueOf(ht.get("D2"))); //채권캠폐인(2)
				t3=AddUtil.parseFloat(String.valueOf(ht.get("D3"))); //채권캠폐인(3)
				t4=AddUtil.parseFloat(String.valueOf(ht.get("D4"))); //채권캠폐인(4)
			//	t_ave_per=AddUtil.parseFloat(String.valueOf(ht.get("AVE_PER"))); //평균연체율(4)
				
				ct1=AddUtil.parseFloat(String.valueOf(ht.get("CD1"))); //채권캠폐인(1)	- 증감			
				ct2=AddUtil.parseFloat(String.valueOf(ht.get("CD2"))); //채권캠폐인(2)
				ct3=AddUtil.parseFloat(String.valueOf(ht.get("CD3"))); //채권캠폐인(3)
				ct4=AddUtil.parseFloat(String.valueOf(ht.get("CD4"))); //채권캠폐인(4)
				
				t_amt1[1] += t1;  //total
				t_amt2[1] += t2;
				t_amt3[1] += t3;
				t_amt4[1] += t4;
				
				ct_amt1[1] += ct1;  //total
				ct_amt2[1] += ct2;
				ct_amt3[1] += ct3;
				ct_amt4[1] += ct4;
		
				
	%>			
      		<tr> 
      		     <td width='2%' align='center'><%=i +1%></td>
                    <td width='10%' align='center'>
           <%  if ( ht.get("NM").equals("퇴사자")) { %>
           퇴사자
           <% } else { %>
           <%    if (ht.get("LOAN_ST").equals("2")){ %>
                   <%=dept_nm%>&nbsp;<% if ( dept_nm.equals("부산지점") || dept_nm.equals("대전지점") ) { %>영업 <%}%>                            
          
           <%}else if( ht.get("LOAN_ST").equals("4")){%>
           			<%=dept_nm%>&nbsp;<% if ( dept_nm.equals("부산지점") || dept_nm.equals("대전지점") ) { %>관리 <%}%>   
            
           <%}else if( ht.get("LOAN_ST").equals("5")){%><%=dept_nm%> <%}%>
           <% } %>     
                    </td>
                    <td width='7%' align='center'><%=ht.get("USER_NM")%></td>
                    <td width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
                    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(t1, 3)%></td> <!--1 -->
                    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(ct1, 3)%></td> <!--1 -->
                    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(t1+ct1, 3)%></td> <!--1 -->
                    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(t2, 3)%></td> <!--2 -->	
                    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(ct2, 3)%></td> <!--2 -->
                    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(t2+ct2, 3)%></td> <!--2 -->
        		    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(t3, 3)%></td> <!--3 -->	
        		    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(ct3, 3)%></td> <!--3 -->
                    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(t3+ct3, 3)%></td> <!--3 -->
        		    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(t4, 3)%></td> <!--4 -->	
        		    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(ct4, 3)%></td> <!--4 -->
                    <td width='5%'align='right'><%=AddUtil.parseFloatCipher2(t4+ct4, 3)%></td> <!--4 -->
        		      <td width='7%' align='right'><%=AddUtil.parseFloatCipher2(t1+ct1+t2+ct2+t3+ct3+t4+ct4, 3)%></td> 	
        		    <td width='7%' align='right'><%=AddUtil.parseFloatCipher2((t1+ct1+t2+ct2+t3+ct3+t4+ct4)/4, 3)%></td> 		
                </tr>
 
<%		}	%>		    
	
           
		 <tr  height="80"> 
		  	<td class=title colspan="4" style='height:44;'>합계<br>평균</td>
		            <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1])%><br><%=Util.parseDecimal(t_amt1[1]/vt_size)%></td> <!--1 -->
		            <td class=title  style='text-align:right'><%=Util.parseDecimal(ct_amt1[1])%><br><%=Util.parseDecimal(ct_amt1[1]/vt_size)%></td> <!--1 -->
                    <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1]+ct_amt1[1])%><br><%=Util.parseDecimal((t_amt1[1]+ct_amt1[1])/vt_size)%></td><!--1-->
        		    <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[1])%><br><%=Util.parseDecimal(t_amt2[1]/vt_size)%></td> <!--2 -->	
        		    <td class=title  style='text-align:right'><%=Util.parseDecimal(ct_amt2[1])%><br><%=Util.parseDecimal(ct_amt2[1]/vt_size)%></td> <!--2 -->
                    <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[1]+ct_amt2[1])%><br><%=Util.parseDecimal((t_amt2[1]+ct_amt2[1])/vt_size)%></td> <!--2 -->
        		    <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[1])%><br><%=Util.parseDecimal(t_amt3[1]/vt_size)%></td> <!--3 -->  
        		    <td class=title  style='text-align:right'><%=Util.parseDecimal(ct_amt3[1])%><br><%=Util.parseDecimal(ct_amt3[1]/vt_size)%></td> <!--3 -->
                    <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[1]+ct_amt3[1])%><br><%=Util.parseDecimal((t_amt3[1]+ct_amt3[1])/vt_size)%></td><!--3 -->
        		    <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[1])%><br><%=Util.parseDecimal(t_amt4[1]/vt_size)%></td> <!--4 -->	
        		    <td class=title  style='text-align:right'><%=Util.parseDecimal(ct_amt4[1])%><br><%=Util.parseDecimal(ct_amt4[1]/vt_size)%></td> <!--4 -->
                    <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[1]+ct_amt4[1])%><br><%=Util.parseDecimal((t_amt4[1]+ct_amt4[1])/vt_size)%></td><!--4 -->
        		   <td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1]+ct_amt1[1]+t_amt2[1]+ct_amt2[1]+t_amt3[1]+ct_amt3[1]+t_amt4[1]+ct_amt4[1])%><br><%=Util.parseDecimal((t_amt1[1]+ct_amt1[1]+t_amt2[1]+ct_amt2[1]+t_amt3[1]+ct_amt3[1]+t_amt4[1]+ct_amt4[1])/vt_size)%></td>  	   
        		   <td class=title  style='text-align:right'></td>        		    
        		
		        </tr>
	        </table>
	    </td>		  
<%	}else{	%>                     
  <tr>		
        <td class='line' width='100%'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center' >등록된 데이타가 없습니다</td>
                </tr>
            </table>
	    </td>
	   
  </tr>
<%	}	%>
</table>	

<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun1' value=>
<input type='hidden' name='gubun2' value=>
</form>
</body>
</html>

<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= false; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 30.0; //상단여백    
		factory.printing.bottomMargin 	= 30.0; //하단여백
		
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
		
	}

</script>