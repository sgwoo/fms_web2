<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cost.*"%>
<%@ page import="acar.common.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1"); //년도
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2"); //항목
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	// gubun2 : 2:영업 1:채권 5:비용 6:제안	
	// 채권 - 외근
	Vector vt = ac_db.getStatCmpList1(gubun1, gubun2);
	
	//채권: 마감시 당일연체율+평균연체율/2
		
	int vt_size =vt.size();
	
	float t_amt1[] = new float[2];   
    float t_amt2[] = new float[2];   
    float t_amt3[] = new float[2];   
    float t_amt4[] = new float[2];   
    float t_amt5[] = new float[2];   
   	float ave_per[] = new float[2];   
    
      
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
      
   //켐페인 포상일자  - 
     String  vt_dt[]	 	= new String[4];
 
     Vector vt1 = ac_db.getSaveDt(gubun1, gubun2);
      
     for(int i = 0 ; i < vt1.size() ; i++){
 		Hashtable ht = (Hashtable)vt1.elementAt(i);
 	
 		if ( i == 0 ) vt_dt[0]=	String.valueOf(ht.get("SAVE_DT"));
 		if ( i == 1 ) vt_dt[1]=	String.valueOf(ht.get("SAVE_DT"));
 		if ( i == 2 ) vt_dt[2]=	String.valueOf(ht.get("SAVE_DT"));
 		if ( i == 3 ) vt_dt[3]=	String.valueOf(ht.get("SAVE_DT"));
 				
 	}
     
 	String content_code = "STAT_CMP";
 	String content_seq  = "";
 	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	 Vector attach_vt =  new Vector();		
	 int attach_vt_size = 0;
     
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//팝업윈도우 열기 - 마감데이타와 차이 - 사용불가 20200116
function viewCamaign(gubun1, gubun2)
{
 
	if ( gubun2 == '1') { //1군
	 	window.open("/acar/account/stat_settle_201103_sc2.jsp?save_dt="+gubun1, "viewCamaign", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	} else { //2군
		window.open("/acar/account/stat_settle_201103_sc3.jsp?save_dt="+gubun1, "viewCamaign", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	}
	
}
//-->
</script>
<script language='javascript'>

</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
        <tr> 
    <td colspan="2" align="left"><font face="굴림" size="2" > 
      <b>&nbsp; * &nbsp <%= gubun1%>년&nbsp;   채권캠페인  </b> </font></td>
  </tr>
  
    <tr>		
        <td class=line>	
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                 <td width="2%" class='title' >순번</td>
                    <td width="12%" class='title' >구분</td>
                    <td width="8%" class='title'>성명</td>
                    <td width="10%" class='title'>입사일</td>
                  
               <%    for (int i=0; i< 4; i++){ %>
                    <td class=title width="10%" ><%=i+1%>                
                <%                
					  content_seq  = vt_dt[i]+"1"+gubun1+"431";
					
					  attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
					  attach_vt_size = attach_vt.size();
						
					  for(int k=0; k< attach_vt.size(); k++){
							Hashtable aht = (Hashtable)attach_vt.elementAt(k);   
							
							if((content_seq).equals(aht.get("CONTENT_SEQ"))){
								file_name1 = String.valueOf(aht.get("FILE_NAME"));
								file_type1 = String.valueOf(aht.get("FILE_TYPE"));
								seq1 = String.valueOf(aht.get("SEQ"));						
							}
					  } 
                
   					if(!file_name1.equals("")){
									%>
						<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
									<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' >[1군]</a>&nbsp;
						<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'>[1군]</a>&nbsp;
						<%}%>
                  <%  } %>     
                  <%                
					  content_seq  = vt_dt[i]+"1"+gubun1+"441";
					
					  attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
					  attach_vt_size = attach_vt.size();
						
					  for(int k=0; k< attach_vt.size(); k++){
							Hashtable aht = (Hashtable)attach_vt.elementAt(k);   
							
							if((content_seq).equals(aht.get("CONTENT_SEQ"))){
								file_name1 = String.valueOf(aht.get("FILE_NAME"));
								file_type1 = String.valueOf(aht.get("FILE_TYPE"));
								seq1 = String.valueOf(aht.get("SEQ"));						
							}
					  } 
                
   					if(!file_name1.equals("")){
									%>
						<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
									<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' >[2군]</a>&nbsp;
						<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'>[2군]</a>&nbsp;
						<%}%>
                  <%  } %>  
               
                    </td>
               <% } %>     
              
                     <td class=title width="10%" >계</td>
                     <td class=title width="10%" >평균</td>
                   
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
				double  t1_ave_per = 0;
				String   s_t_ave_per = "";
				float  t_ave_per = 0;
			
				// gubun2 : 2:영업 1:채권 5:비용 6:제안	
			
				t1=AddUtil.parseFloat(String.valueOf(ht.get("D1"))); //채권캠폐인(1)				
				t2=AddUtil.parseFloat(String.valueOf(ht.get("D2"))); //채권캠폐인(2)
				t3=AddUtil.parseFloat(String.valueOf(ht.get("D3"))); //채권캠폐인(3)
				t4=AddUtil.parseFloat(String.valueOf(ht.get("D4"))); //채권캠폐인(4)
				
				// 마감년도인 경우 마감평균으로
//				if ( gubun1.equals("2011") )  {
//						t1_ave_per =(double) (t1+t2+t3+t4) / 4 ;
//						s_t_ave_per = AddUtil.longDouble2String(3, t1_ave_per);
//						t_ave_per = AddUtil.parseFloat(s_t_ave_per);						
//				} else {
						t_ave_per=AddUtil.parseFloat(String.valueOf(ht.get("AVE_PER1"))); //평균연체율(4) - ave_per1:마감시 평균연체율, ave_per:현재 평균연체율!
//				}
				
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
                <tr  height="80"> 
                    <td class=title colspan="4" style='height:34;'>소계<br>평균</td>              
                       <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_cnt)%></td> <!--1 -->
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_cnt)%></td> <!--2 -->	
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_cnt)%></td> <!--3 -->  
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_cnt)%></td> <!--4 -->		
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])/vt_cnt)%></td> <!--4 -->			
        		   <td class=title  style='text-align=right'></td>
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
                   <%=dept_nm%>&nbsp;<% if ( dept_nm.equals("부산지점") || dept_nm.equals("대전지점")  || dept_nm.equals("대구지점")   || dept_nm.equals("수원지점")   || dept_nm.equals("광주지점")  ) { %> <%}%>                            
          
           <%}else if( ht.get("LOAN_ST").equals("4")){%>
           			<%=dept_nm%>&nbsp;<% if ( dept_nm.equals("부산지점") || dept_nm.equals("대전지점")  || dept_nm.equals("대구지점")   || dept_nm.equals("수원지점")  || dept_nm.equals("광주지점") ) { %> <%}%>   
            
           <%}else if( ht.get("LOAN_ST").equals("5")){%><%=dept_nm%> <%}%>
           <% } %>     
                    </td>
                    <td width='8%' align='center'><%=ht.get("USER_NM")%></td>
                    <td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
               
                    <td width='10%' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("D1")), 3)%></td> <!--1 -->
                    <td width='10%' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("D2")), 3)%></td> <!--2 -->	
        		    <td width='10%' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("D3")), 3)%></td> <!--3 -->	
        		    <td width='10%' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("D4")), 3)%></td> <!--4 -->	
        		    <td width='10%' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("SUM_PER1")), 3)%></td> 	
        		    <td width='10%' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("AVE_PER1")), 3)%></td> 	
                </tr>
 
<%		}	%>		    
			    <tr  height="80"> 
                    <td class=title colspan="4" style='height:34;'>소계<br>평균</td>
                 <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[0])%><br><%=Util.parseDecimal(t_amt1[0]/vt_cnt)%></td> <!--1 -->
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt2[0])%><br><%=Util.parseDecimal(t_amt2[0]/vt_cnt)%></td> <!--2 -->	
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt3[0])%><br><%=Util.parseDecimal(t_amt3[0]/vt_cnt)%></td> <!--3 -->  
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt4[0])%><br><%=Util.parseDecimal(t_amt4[0]/vt_cnt)%></td> <!--4 -->		
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])%><br><%=Util.parseDecimal((t_amt1[0]+t_amt2[0]+t_amt3[0]+t_amt4[0])/vt_cnt)%></td> <!--4 -->			
                	<td class=title  style='text-align=right'></td>	
                </tr>
		        <tr  height="80"> 		
		   	<td class=title colspan="4" style='height:34;'>합계<br>평균</td>		    
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[1])%><br><%=Util.parseDecimal(t_amt1[1]/vt_size)%></td> <!--1 -->
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt2[1])%><br><%=Util.parseDecimal(t_amt2[1]/vt_size)%></td> <!--2 -->	
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt3[1])%><br><%=Util.parseDecimal(t_amt3[1]/vt_size)%></td> <!--3 -->  
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt4[1])%><br><%=Util.parseDecimal(t_amt4[1]/vt_size)%></td> <!--4 -->	
        		    <td class=title  style='text-align=right'><%=Util.parseDecimal(t_amt1[1]+t_amt2[1]+t_amt3[1]+t_amt4[1])%><br><%=Util.parseDecimal((t_amt1[1]+t_amt2[1]+t_amt3[1]+t_amt4[1])/vt_cnt)%></td> <!--4 -->	
        		   <td class=title  style='text-align=right'></td> 
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
<!-- 평가기준 -->
  <table width="1000" border="0" cellspacing="0" cellpadding="0">
  	<tr> 
      <td colspan=2><font color="#FF00FF">♣ 기준</font>       : 캠페인마감실적 중   (당일연체율+마감연체율)/2로 계산
        &nbsp;&nbsp;</td>
   	</tr>
   </table>	
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun1' value=>
<input type='hidden' name='gubun2' value=>
</form>
</body>
</html>



