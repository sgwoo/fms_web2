<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cost.*"%>

<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //년도
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2"); //항목
		
	// gubun2 :  7:관리대수 (고객지원팀)
	Vector vt = ac_db.getStatCmpList7(gubun1, gubun2);
		
	int vt_size =vt.size();
	
	long t_amt1[] = new long[2];   
    long t_amt2[] = new long[2];   
    long t_amt3[] = new long[2];   
    long t_amt4[] = new long[2];   
    long t_amt5[] = new long[2];   
    long t_amt6[] = new long[2];   
    long t_amt7[] = new long[2];   
    long t_amt8[] = new long[2];   
          
   	float ave_per[] = new float[2];   
 
    
    String loan_chk = "";
    int    loan_cnt = 1;
    int    t_loan_cnt = 1;
    
    int tp_amt0 = 0;
    int tp_amt1 = 0;
    int tp_amt2 = 0;
    int tp_amt3 = 0;      
    
    String dept_nm = "";
	
	String br_chk = "";
	int		br_cnt = 1;
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
      <b>&nbsp; * &nbsp <%= gubun1%>년&nbsp; 관리대수 </b> </font></td>
  </tr>
  
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                 <tr> 
                 <td rowspan=2 width="2%" class='title' >순번</td>
                    <td rowspan=2 width="7%" class='title' >구분</td>
                    <td rowspan=2 width="5%" class='title'>성명</td>
                    <td rowspan=2 width="6%" class='title'>입사일</td>             
        	          <td colspan=4 class=title>1</td>
                    <td colspan=4 class=title>2</td>
                    <td colspan=4 class=title>3</td>
                    <td colspan=4 class=title>4</td>
                    <td colspan=4 class=title>합계</td>                    
               </tr>      
               <tr>     
                    <td class=title width='4%' >일반</td>
                    <td class=title width='4%' >기본</td>
                    <td class=title width='4%' >계</td>
                    <td class=title width='4%' >적용</td>
                    <td class=title width='4%' >일반</td>
                    <td class=title width='4%' >기본</td>
                    <td class=title width='4%' >계</td>
                    <td class=title width='4%' >적용</td>
                    <td class=title width='4%' >일반</td>
                    <td class=title width='4%' >기본</td>
                    <td class=title width='4%' >계</td>
                    <td class=title width='4%' >적용</td>
                    <td class=title width='4%' >일반</td>
                    <td class=title width='4%' >기본</td>
                    <td class=title width='4%' >계</td>
                    <td class=title width='4%' >적용</td>
                    <td class=title width='4%' >일반</td>
                    <td class=title width='4%' >기본</td>
                    <td class=title width='4%' >계</td>
                    <td class=title width='4%' >적용</td>   
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
				    //loan_chk = String.valueOf(ht.get("LOAN_ST"));
					br_chk = String.valueOf(ht.get("BR_ID"));
				}		
											
				//명칭
				dept_nm = ad_db.getUserDeptNm(String.valueOf(ht.get("USER_ID")));
						
				long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;
				long t5=0; //계
				float t_ave_per = 0;
				
				long ct1=0;
				long ct2=0;
				long ct3=0;
				long ct4=0;
			
				// gubun2 : 1:채권 	
			
				t1=AddUtil.parseLong(String.valueOf(ht.get("D1"))); //일반식(1)				
				t2=AddUtil.parseLong(String.valueOf(ht.get("D2"))); //일반식(2)
				t3=AddUtil.parseLong(String.valueOf(ht.get("D3"))); //일반식(3)
				t4=AddUtil.parseLong(String.valueOf(ht.get("D4"))); //일반식(4)
			//	t_ave_per=AddUtil.parseFloat(String.valueOf(ht.get("AVE_PER"))); //평균연체율(4)
				
				ct1=AddUtil.parseLong(String.valueOf(ht.get("CD1"))); //기본식(1)	- 증감			
				ct2=AddUtil.parseLong(String.valueOf(ht.get("CD2"))); //기본식(2)
				ct3=AddUtil.parseLong(String.valueOf(ht.get("CD3"))); //기본식(3)
				ct4=AddUtil.parseLong(String.valueOf(ht.get("CD4"))); //기본식(4)
				
				t_amt1[1] += t1;  //total
				t_amt2[1] += t2;
				t_amt3[1] += t3;
				t_amt4[1] += t4;
				
				t_amt5[1] += ct1;  //total
				t_amt6[1] += ct2;
				t_amt7[1] += ct3;
				t_amt8[1] += ct4;
				
  			//	if ( loan_chk.equals(String.valueOf(ht.get("LOAN_ST")))) {        
  				if ( br_chk.equals(String.valueOf(ht.get("BR_ID")))) {  				
					for(int j=0; j<1; j++){
							t_amt1[j] += t1;
							t_amt2[j] += t2;
							t_amt3[j] += t3;
							t_amt4[j] += t4;	
							
							t_amt5[j] += ct1;
							t_amt6[j] += ct2;
							t_amt7[j] += ct3;
							t_amt8[j] += ct4;					
					}
					vt_cnt += 1;
				}
				
	%>			
<%    if ( !br_chk.equals(String.valueOf(ht.get("BR_ID")))) {  %>        
                <tr  height="80"> 
                    <td class=title colspan="4" style='height:34;'>소계<br>평균</td>
				<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_cnt)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt5[0])%><br><%=Util.parseDecimal(t_amt5[0]/vt_cnt)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt5[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt5[0])/vt_cnt)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt1[0]*3)+t_amt5[0])%><br><%=Util.parseDecimal(((t_amt1[0]*3)+t_amt5[0])/vt_cnt)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_cnt)%></td> <!--2 -->	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt6[0])%><br><%=Util.parseDecimal(t_amt6[0]/vt_cnt)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[0]+t_amt6[0])%><br><%=Util.parseDecimal((t_amt2[0]+t_amt6[0])/vt_cnt)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt2[0]*3)+t_amt6[0])%><br><%=Util.parseDecimal(((t_amt2[0]*3)+t_amt6[0])/vt_cnt)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_cnt)%></td> <!--3 -->  
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt7[0])%><br><%=Util.parseDecimal(t_amt7[0]/vt_cnt)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[0]+t_amt7[0])%><br><%=Util.parseDecimal((t_amt3[0]+t_amt7[0])/vt_cnt)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt3[0]*3)+t_amt7[0])%><br><%=Util.parseDecimal(((t_amt3[0]*3)+t_amt7[0])/vt_cnt)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_cnt)%></td> <!--4 -->	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt8[0])%><br><%=Util.parseDecimal(t_amt8[0]/vt_cnt)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[0]+t_amt8[0])%><br><%=Util.parseDecimal((t_amt4[0]+t_amt8[0])/vt_cnt)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt4[0]*3)+t_amt8[0])%><br><%=Util.parseDecimal(((t_amt4[0]*3)+t_amt8[0])/vt_cnt)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])/vt_cnt)%></td>  	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt5[0]+t_amt6[0]+t_amt7[0]+t_amt8[0])%><br><%=Util.parseDecimal((t_amt5[0]+t_amt6[0]+t_amt7[0]+t_amt8[0])/vt_cnt)%></td>  
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt5[0]+t_amt2[0]+t_amt6[0]+t_amt3[0]+t_amt7[0]+t_amt4[0]+t_amt8[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt5[0]+t_amt2[0]+t_amt6[0]+t_amt3[0]+t_amt7[0]+t_amt4[0]+t_amt8[0])/vt_cnt)%></td>
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt1[0]*3)+t_amt5[0]+(t_amt2[0]*3)+t_amt6[0]+(t_amt3[0]*3)+t_amt7[0]+(t_amt4[0]*3)+t_amt8[0])%><br><%=Util.parseDecimal(((t_amt1[0]*3)+t_amt5[0]+(t_amt2[0]*3)+t_amt6[0]+(t_amt3[0]*3)+t_amt7[0]+(t_amt4[0]*3)+t_amt8[0])/vt_cnt)%>
					</td> 			
                </tr>
<%		
       		 br_chk = String.valueOf(ht.get("BR_ID"));
       		 
			 t_amt1[0] = t1;
			 t_amt2[0] = t2;
			 t_amt3[0] = t3;
		 	 t_amt4[0] = t4;	
		 	 t_amt5[0] = ct1;
			 t_amt6[0] = ct2;
			 t_amt7[0] = ct3;
		 	 t_amt8[0] = ct4;
		 	 vt_cnt = 1;
		 	 
        }
%> 
           		<tr> 
           		     <td width='2%' align='center'><%=i+1%></td>
                    <td width='7%' align='center'>
           <%  if ( ht.get("NM").equals("퇴사자")) { %>
           퇴사자
           <% } else { %>
           <%    if (ht.get("LOAN_ST").equals("2")){ %>
                   <%=dept_nm%>&nbsp;<% if ( dept_nm.equals("부산지점") || dept_nm.equals("대전지점")  || dept_nm.equals("광주지점")  || dept_nm.equals("대구지점")  || dept_nm.equals("수원지점") ) { %> <%}%>                            
          
           <%}else if( ht.get("LOAN_ST").equals("4")){%>
           			<%=dept_nm%>&nbsp;<% if ( dept_nm.equals("부산지점") || dept_nm.equals("대전지점")  || dept_nm.equals("광주지점")   || dept_nm.equals("대구지점")   || dept_nm.equals("수원지점") ) { %> <%}%>   
            
           <%}else if( ht.get("LOAN_ST").equals("5")){%><%=dept_nm%> <%}%>
           <% } %>     
                    </td>
                    <td width='5%' align='center'><%=ht.get("USER_NM")%></td>
                    <td width='6%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
                     <td width='4%' align='right'><%=Util.parseDecimal(t1)%></td> <!--1 -->
                    <td width='4%' align='right'><%=Util.parseDecimal(ct1)%></td> <!--1 -->
                    <td width='4%' align='right'><%=Util.parseDecimal(t1+ct1)%></td> <!--1 -->
                    <td width='4%' align='right'><%=Util.parseDecimal((t1*3)+ct1)%></td> <!--1 -->
					
                    <td width='4%' align='right'><%=Util.parseDecimal(t2)%></td> <!--2 -->	
                    <td width='4%' align='right'><%=Util.parseDecimal(ct2)%></td> <!--2 -->
                    <td width='4%' align='right'><%=Util.parseDecimal(t2+ct2)%></td> <!--2 -->
                    <td width='4%' align='right'><%=Util.parseDecimal((t2*3)+ct2)%></td> <!--2 -->
			
		<td width='4%' align='right'><%=Util.parseDecimal(t3)%></td> <!--3 -->	
		<td width='4%' align='right'><%=Util.parseDecimal(ct3)%></td> <!--3 -->
		<td width='4%' align='right'><%=Util.parseDecimal(t3+ct3)%></td> <!--3 -->
		<td width='4%' align='right'><%=Util.parseDecimal((t3*3)+ct3)%></td> <!--3 -->
		
		<td width='4%' align='right'><%=Util.parseDecimal(t4)%></td> <!--4 -->	
		<td width='4%' align='right'><%=Util.parseDecimal(ct4)%></td> <!--4 -->
		<td width='4%' align='right'><%=Util.parseDecimal(t4+ct4)%></td> <!--4 -->
		<td width='4%' align='right'><%=Util.parseDecimal((t4*3)+ct4)%></td> <!--4 -->                    
		
		<td width='4%' align='right'><%=Util.parseDecimal(t1+t2+t3+t4)%></td> <!--tot -->	
		<td width='4%' align='right'><%=Util.parseDecimal(ct1+ct2+ct3+ct4)%></td> <!--tot -->
		<td width='4%' align='right'><%=Util.parseDecimal(t1+t2+t3+t4+ct1+ct2+ct3+ct4)%></td> <!--tot -->
		<td width='4%' align='right'><%=Util.parseDecimal((t1*3)+ct1 + (t2*3)+ct2 + (t3*3)+ct3+(t4*3)+ct4)%></td> <!--tot -->       
                </tr>
 
<%		}	%>		    
				<tr  height="80"> 
                    <td class=title colspan="4" style='height:34;'>소계<br>평균</td>
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_cnt)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt5[0])%><br><%=Util.parseDecimal(t_amt5[0]/vt_cnt)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt5[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt5[0])/vt_cnt)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt1[0]*3)+t_amt5[0])%><br><%=Util.parseDecimal(((t_amt1[0]*3)+t_amt5[0])/vt_cnt)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_cnt)%></td> <!--2 -->	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt6[0])%><br><%=Util.parseDecimal(t_amt6[0]/vt_cnt)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[0]+t_amt6[0])%><br><%=Util.parseDecimal((t_amt2[0]+t_amt6[0])/vt_cnt)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt2[0]*3)+t_amt6[0])%><br><%=Util.parseDecimal(((t_amt2[0]*3)+t_amt6[0])/vt_cnt)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_cnt)%></td> <!--3 -->  
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt7[0])%><br><%=Util.parseDecimal(t_amt7[0]/vt_cnt)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[0]+t_amt7[0])%><br><%=Util.parseDecimal((t_amt3[0]+t_amt7[0])/vt_cnt)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt3[0]*3)+t_amt7[0])%><br><%=Util.parseDecimal(((t_amt3[0]*3)+t_amt7[0])/vt_cnt)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_cnt)%></td> <!--4 -->	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt8[0])%><br><%=Util.parseDecimal(t_amt8[0]/vt_cnt)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[0]+t_amt8[0])%><br><%=Util.parseDecimal((t_amt4[0]+t_amt8[0])/vt_cnt)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt4[0]*3)+t_amt8[0])%><br><%=Util.parseDecimal(((t_amt4[0]*3)+t_amt8[0])/vt_cnt)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])/vt_cnt)%></td>  	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt5[0]+t_amt6[0]+t_amt7[0]+t_amt8[0])%><br><%=Util.parseDecimal((t_amt5[0]+t_amt6[0]+t_amt7[0]+t_amt8[0])/vt_cnt)%></td>  
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[0]+t_amt5[0]+t_amt2[0]+t_amt6[0]+t_amt3[0]+t_amt7[0]+t_amt4[0]+t_amt8[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt5[0]+t_amt2[0]+t_amt6[0]+t_amt3[0]+t_amt7[0]+t_amt4[0]+t_amt8[0])/vt_cnt)%></td>
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt1[0]*3)+t_amt5[0]+(t_amt2[0]*3)+t_amt6[0]+(t_amt3[0]*3)+t_amt7[0]+(t_amt4[0]*3)+t_amt8[0])%><br><%=Util.parseDecimal(((t_amt1[0]*3)+t_amt5[0]+(t_amt2[0]*3)+t_amt6[0]+(t_amt3[0]*3)+t_amt7[0]+(t_amt4[0]*3)+t_amt8[0])/vt_cnt)%>
					</td> 						
                </tr>
		   <tr  height="80"> 
					<td class=title colspan="4" style='height:34;'>합계<br>평균</td>
		        			<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1])%><br><%=Util.parseDecimal(t_amt1[1]/vt_size)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt5[1])%><br><%=Util.parseDecimal(t_amt5[1]/vt_size)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1]+t_amt5[1])%><br><%=Util.parseDecimal((t_amt1[1]+t_amt5[1])/vt_size)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt1[1]*3)+t_amt5[1])%><br><%=Util.parseDecimal(((t_amt1[1]*3)+t_amt5[1])/vt_size)%></td> <!--1 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[1])%><br><%=Util.parseDecimal(t_amt2[1]/vt_size)%></td> <!--2 -->	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt6[1])%><br><%=Util.parseDecimal(t_amt6[1]/vt_size)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt2[1]+t_amt6[1])%><br><%=Util.parseDecimal((t_amt2[1]+t_amt6[1])/vt_size)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt2[1]*3)+t_amt6[1])%><br><%=Util.parseDecimal(((t_amt2[1]*3)+t_amt6[1])/vt_size)%></td> <!--2 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[1])%><br><%=Util.parseDecimal(t_amt3[1]/vt_size)%></td> <!--3 -->  
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt7[1])%><br><%=Util.parseDecimal(t_amt7[1]/vt_size)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt3[1]+t_amt7[1])%><br><%=Util.parseDecimal((t_amt3[1]+t_amt7[1])/vt_size)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt3[1]*3)+t_amt7[1])%><br><%=Util.parseDecimal(((t_amt3[1]*3)+t_amt7[1])/vt_size)%></td> <!--3 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[1])%><br><%=Util.parseDecimal(t_amt4[1]/vt_size)%></td> <!--4 -->	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt8[1])%><br><%=Util.parseDecimal(t_amt8[1]/vt_size)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt4[1]+t_amt8[1])%><br><%=Util.parseDecimal((t_amt4[1]+t_amt8[1])/vt_size)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt4[1]*3)+t_amt8[1])%><br><%=Util.parseDecimal(((t_amt4[1]*3)+t_amt8[1])/vt_size)%></td> <!--4 -->
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1]+t_amt2[1]+t_amt3[1]+t_amt4[1])%><br><%=Util.parseDecimal((t_amt1[1]+t_amt2[1]+t_amt3[1]+t_amt4[1])/vt_size)%></td>  	
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt5[1]+t_amt6[1]+t_amt7[1]+t_amt8[1])%><br><%=Util.parseDecimal((t_amt5[1]+t_amt6[1]+t_amt7[1]+t_amt8[1])/vt_size)%></td>  
					<td class=title  style='text-align:right'><%=Util.parseDecimal(t_amt1[1]+t_amt5[1]+t_amt2[1]+t_amt6[1]+t_amt3[1]+t_amt7[1]+t_amt4[1]+t_amt8[1])%><br><%=Util.parseDecimal((t_amt1[1]+t_amt5[1]+t_amt2[1]+t_amt6[1]+t_amt3[1]+t_amt7[1]+t_amt4[1]+t_amt8[1])/vt_size)%></td>
					<td class=title  style='text-align:right'><%=Util.parseDecimal((t_amt1[1]*3)+t_amt5[1]+(t_amt2[1]*3)+t_amt6[1]+(t_amt3[1]*3)+t_amt7[1]+(t_amt4[1]*3)+t_amt8[1])%><br><%=Util.parseDecimal(((t_amt1[1]*3)+t_amt5[1]+(t_amt2[1]*3)+t_amt6[1]+(t_amt3[1]*3)+t_amt7[1]+(t_amt4[1]*3)+t_amt8[1])/vt_size)%>
					</td>  
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
<br>
 
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
