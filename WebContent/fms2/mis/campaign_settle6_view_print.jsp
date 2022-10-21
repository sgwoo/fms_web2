<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cost.*"%>

<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //년도
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2"); //항목
		
	// gubun2 : 2:영업 1:채권 5:비용 6:제안	
	Vector vt = ac_db.getStatCmpList(gubun1, gubun2, "");
		
	int vt_size =vt.size();
	
	float t_amt1[] = new float[2];   
    float t_amt2[] = new float[2];   
    float t_amt3[] = new float[2];   
    float t_amt4[] = new float[2];   
    float t_amt5[] = new float[2];   
      
    long t_amt21[] = new long[2];
    long t_amt22[] = new long[2];  
    long t_amt23[] = new long[2];  
    long t_amt24[] = new long[2];  
    
    String loan_chk = "";
    int    loan_cnt = 1;
    int    t_loan_cnt = 1;
    
    int tp_amt0 = 0;
    int tp_amt1 = 0;
    int tp_amt2 = 0;
    int tp_amt3 = 0;      
    
    String dept_nm = "";
    
    int vt_cnt = 0;
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
      <b>&nbsp; * &nbsp <%= gubun1%>년&nbsp;   영업캠페인 </b> </font></td>
  </tr>
  
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                  <td width="2%" class='title' >순번</td>
                    <td width="12%" class='title' >구분</td>
                    <td width="8%" class='title'>성명</td>
                    <td width="10%" class='title'>입사일</td>
                    <td class=title width="12%" >1</td>
                    <td class=title width="12%" >2</td>
                    <td class=title width="12%" >3</td>
                    <td class=title width="12%" >4</td>
                    <td class=title width="12%" >계</td>
                   
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
			
				// gubun2 : 2:영업 1:채권 5:비용 6:제안	
				if ( gubun2.equals("2") )  { //영업									
					t1=AddUtil.parseFloat(String.valueOf(ht.get("S1"))); //영업캠페인(1)				
					t2=AddUtil.parseFloat(String.valueOf(ht.get("S2"))); //영업캠페인(2)
					t3=AddUtil.parseFloat(String.valueOf(ht.get("S3"))); //영업캠페인(3)
					t4=AddUtil.parseFloat(String.valueOf(ht.get("S4"))); //영업캠페인(4)
				} else if ( gubun2.equals("5") ) {								
					t1=AddUtil.parseFloat(String.valueOf(ht.get("C1"))); //비용캠페인(1)					
					t2=AddUtil.parseFloat(String.valueOf(ht.get("C2"))); //비용캠페인(2)
					t3=AddUtil.parseFloat(String.valueOf(ht.get("C3"))); //비용캠폐인(3)
				} else if ( gubun2.equals("6") ) {	
					t1=AddUtil.parseFloat(String.valueOf(ht.get("P1"))); //제안캠폐인(1)	
					t2=AddUtil.parseFloat(String.valueOf(ht.get("P2"))); //제안캠폐인(2)
					t3=AddUtil.parseFloat(String.valueOf(ht.get("P3"))); //제안캠폐인(3)
				}
				
				t_amt1[1] += t1;  //total
				t_amt2[1] += t2;
				t_amt3[1] += t3;
				t_amt4[1] += t4;

  				if ( loan_chk.equals(String.valueOf(ht.get("LOAN_ST")))) {        
  								
					for(int j=0; j<1; j++){
							t_amt1[j] += t1;
							t_amt2[j] += t2;
							t_amt3[j] += t3;
							t_amt4[j] += t4;					
					}
					
					vt_cnt += 1;
				}
				
				
				
	%>			
<%    if ( !loan_chk.equals(String.valueOf(ht.get("LOAN_ST")))) {  %>        
	<%	//out.print("vt_cnt="+vt_cnt); %>
	            <tr  height="80"> 
                    <td class=title colspan="4" style='height:34;'>소계<br>평균</td>                   		    
    		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_cnt)%></td> <!--1 -->
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_cnt)%></td> <!--2 -->	
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_cnt)%></td> <!--3 -->  
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_cnt)%></td> <!--4 -->		
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])/vt_cnt)%></td> <!--4 -->			
  
                </tr>
<%		
			 loan_chk = String.valueOf(ht.get("LOAN_ST"));
       		 
			 t_amt1[0] = t1;
			 t_amt2[0] = t2;
			 t_amt3[0] = t3;
		 	 t_amt4[0] = t4;	
		 	 
		 	vt_cnt = 1;
		 	 
        }
        
  
%>   
           		<tr> 
           	  <td width='2%' align='center'><%=i+1%></td>
                    <td width='12%' align='center'>
           <%  if ( ht.get("NM").equals("퇴사자")) { %>
           퇴사자
           <% } else { %>
           <%    if (ht.get("LOAN_ST").equals("2")){ %>
                   <%=dept_nm%>&nbsp;<% if ( dept_nm.equals("부산지점") || dept_nm.equals("대전지점")   || dept_nm.equals("대구지점")   || dept_nm.equals("수원지점")   || dept_nm.equals("광주지점")   ) { %> <%}%>                            
          
           <%}else if( ht.get("LOAN_ST").equals("4")){%>
           			<%=dept_nm%>&nbsp;<% if ( dept_nm.equals("부산지점") || dept_nm.equals("대전지점")   || dept_nm.equals("대구지점")   || dept_nm.equals("수원지점")   || dept_nm.equals("광주지점") ) { %> <%}%>   
            
           <%}else if( ht.get("LOAN_ST").equals("5")){%><%=dept_nm%> <%}%>
           <% } %>     
                    </td>
                    <td width='8%' align='center'><%=ht.get("USER_NM")%></td>
                    <td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
                    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t1, 2)%></td> <!--1 -->
                    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t2, 2)%></td> <!--2 -->	
        		    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t3, 2)%></td> <!--3 -->	
        		    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t4, 2)%></td> <!--4 -->	
        		    <td width='12%' align='right'><%=AddUtil.parseFloatCipher2(t1+t2+t3+t4, 2)%></td> 	
                </tr>
 
<%		}	%>		
<%	//out.print("vt_cnt="+vt_cnt); %>    
			    <tr  height="80"> 
                    <td class=title colspan="4" style='height:34;'>소계<br>평균</td>
                    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_cnt)%></td> <!--1 -->
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_cnt)%></td> <!--2 -->	
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_cnt)%></td> <!--3 -->  
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_cnt)%></td> <!--4 -->		
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])/vt_cnt)%></td> <!--4 -->			
                </tr>
		        <tr  height="80"> 
		        	<td class=title colspan="4" style='height:34;'>합계<br>평균</td>
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1])%><br><%=Util.parseDecimal(t_amt1[1]/vt_size)%></td> <!--1 -->
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[1])%><br><%=Util.parseDecimal(t_amt2[1]/vt_size)%></td> <!--2 -->	
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[1])%><br><%=Util.parseDecimal(t_amt3[1]/vt_size)%></td> <!--3 -->  
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[1])%><br><%=Util.parseDecimal(t_amt4[1]/vt_size)%></td> <!--4 -->	
        		    <td  class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1]+t_amt2[1]+t_amt3[1]+t_amt4[1])%><br><%=Util.parseDecimal((t_amt1[1]+t_amt2[1]+t_amt3[1]+t_amt4[1])/vt_size)%></td> <!--4 -->	
        		    
        		
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
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 30.0; //상단여백    
		factory.printing.bottomMargin 	= 30.0; //하단여백
		
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
		
	}

</script>
