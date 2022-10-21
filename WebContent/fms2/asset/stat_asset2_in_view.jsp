<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"5":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	
	AssetDatabase a_db = AssetDatabase.getInstance();
		
	
	int f_year 	= 2013;	
	int f_year_m	= 2012;	
	int years 	= AddUtil.getDate2(1)-f_year+1;
		
	int cnt1[]	 = new int[years+1];
	int cnt2[]	 = new int[years+1];
	int cnt3[]	 = new int[years+1];
	
	float acnt1[]	 = new float[years+1];
	float acnt2[]	 = new float[years+1];
	float acnt3[]	 = new float[years+1];
	
	int h_cnt[]	= new int[years+1];
	int t_cnt[]		= new int[years+1];
	
	float ah_cnt[]	= new float[years+1];
	float at_cnt[]	= new float[years+1];
	
	float a_cnt[]	= new float[years+1];

	
	String bus_st1_nm[]	 	= new String[3];
	bus_st1_nm[0] = "승용";
	bus_st1_nm[1] = "승합";
	bus_st1_nm[2] = "화물";

		
	String bus_st2_nm[]	 	= new String[2];
	bus_st2_nm[0] = "LPG";
	bus_st2_nm[1] = "비LPG";
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
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
//-->
</script>
<script language='javascript'>
<!--

	
	
	//해지현황 리스트 이동
	function view_actn(s_yy)
	{
		var fm = document.form1;
		var url = "";
		fm.s_yy.value = s_yy;	
					
		url = "/fms2/asset/stat_asset1.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
	
			
//-->
</script>

</head>
<body onLoad="javascript:init()">
<form  name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>

  <table border=0 cellspacing=0 cellpadding=0 width=<%=40+110+(120*years)%>>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
     <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2"  colspan=2 class=title>구분</td>
                 
					<%for (int j = f_year ; j <= AddUtil.getDate2(1) ; j++){%>
                    <td width=120 class=title colspan=2><%=j%>년</td>
					<%}%>
                </tr>
                  <tr align="center"> 
                               
					<%for (int j = f_year ; j <= AddUtil.getDate2(1) ; j++){%>
                    <td width=60 class=title>대수</td>
                    <td width=60 class=title>차령</td>
                   
					<%}%>
                </tr>
<!--리스-->
	
				<%	Vector vt = a_db.getAssetIncomCarAgeList("1", f_year);
					int vt_size = vt.size();%>		
					
			<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						
						if(String.valueOf(ht.get("GUBUN")).equals("3")){
							for (int j = (f_year-f_year_m -1 ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){
								cnt1[j] 	= Integer.parseInt((String)ht.get("CNT"+j));
								acnt1[j] 	=  Float.parseFloat((String)ht.get("AGE"+j));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];																
								t_cnt[j] 	= t_cnt[j] + cnt1[j];		
								
								ah_cnt[j] 	= ah_cnt[j]  + acnt1[j];																
								at_cnt[j] 	= at_cnt[j] + acnt1[j];								
								
							}
						}
						
						if(String.valueOf(ht.get("GUBUN")).equals("1")){
							for (int j = (f_year-f_year_m -1 ); j <= (AddUtil.getDate2(1)-f_year_m) ; j++){
								cnt2[j] 	= Integer.parseInt((String)ht.get("CNT"+(j)));
								acnt2[j] 	=  Float.parseFloat((String)ht.get("AGE"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								t_cnt[j] 	= t_cnt[j] + cnt2[j];
								
								ah_cnt[j] 	= ah_cnt[j]  + acnt2[j];																
								at_cnt[j] 	= at_cnt[j] + acnt2[j];		
										
							}
						}
						
						if(String.valueOf(ht.get("GUBUN")).equals("2")){
							for (int j = (f_year-f_year_m -1 ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){
								cnt3[j] 	=Integer.parseInt((String)ht.get("CNT"+(j)));
								acnt3[j] 	=  Float.parseFloat((String)ht.get("AGE"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt3[j];
								t_cnt[j] 	= t_cnt[j] + cnt3[j];
								
								ah_cnt[j] 	= ah_cnt[j]  + acnt3[j];																
								at_cnt[j] 	= at_cnt[j] + acnt3[j];		
								
							}
						}
										
					}					
				%>
			              
  			<%	for(int i = 0 ; i < 3 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="40" rowspan="4" align="center">리스</td><%}%>                  
                    <td width="110" align="center"><%=bus_st1_nm[i]%></td>					
					<%	for (int j = (f_year-f_year_m  ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=Util.parseDecimal(cnt1[j])%>
						<%}else if(i==1){%>	<%=Util.parseDecimal(cnt2[j])%>
						<%}else if(i==2){%>	<%=Util.parseDecimal(cnt3[j])%>					
						<%}%>
					</td>
		   <td align="right">
						<%if(i==0){%>		<%=AddUtil.parseFloatCipher2(acnt1[j]/cnt1[j],1)%>
						<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher2(acnt2[j]/cnt2[j],1)%>
						<%}else if(i==2){%>	<%=AddUtil.parseFloatCipher2(acnt3[j]/cnt3[j],1)%>					
						<%}%>
					</td>
					
					<%	}%>
                </tr>	
                <%	}%>
              <tr>
					<td class=title>소계 평균 </td>
					<%	for (int j = (f_year-f_year_m  ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){%>	
                    <td class=title style='text-align:right'><%=Util.parseDecimal(h_cnt[j])%><br><%=Util.parseDecimal(ah_cnt[j])%></td>
                    <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher2(ah_cnt[j]/h_cnt[j],1)%></td>
         
					<%	}%>					
				</tr>	
				
		<%	for (int j = (f_year-f_year_m -1 ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){
						cnt1[j] = 0;
						cnt2[j] = 0;
						cnt3[j] = 0;					
						h_cnt[j] = 0;
						
						acnt1[j] = 0;
						acnt2[j] = 0;
						acnt3[j] = 0;					
						ah_cnt[j] = 0;
					}%>		
             
		<!--렌트-->	
				<%	vt =  a_db.getAssetIncomCarAgeList("2", f_year);
					vt_size = vt.size();%>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						
						if(String.valueOf(ht.get("GUBUN")).equals("4")){
							for (int j = (f_year-f_year_m -1) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){
							
								cnt1[j] 	= Integer.parseInt((String)ht.get("CNT"+j));
								acnt1[j] 	=  Float.parseFloat((String)ht.get("AGE"+j));
								h_cnt[j] 	= h_cnt[j]  + cnt1[j];																
								t_cnt[j] 	= t_cnt[j] + cnt1[j];		
								
								ah_cnt[j] 	= ah_cnt[j]  + acnt1[j];																
								at_cnt[j] 	= at_cnt[j] + acnt1[j];			
								
							}
						}
						
						if(String.valueOf(ht.get("GUBUN")).equals("5")){
							for (int j = (f_year-f_year_m -1 ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){
								cnt2[j] 	= Integer.parseInt((String)ht.get("CNT"+(j)));
								acnt2[j] 	=  Float.parseFloat((String)ht.get("AGE"+(j)));
								h_cnt[j] 	= h_cnt[j]  + cnt2[j];
								t_cnt[j] 	= t_cnt[j] + cnt2[j];
								
								ah_cnt[j] 	= ah_cnt[j]  + acnt2[j];																
								at_cnt[j] 	= at_cnt[j] + acnt2[j];	
							}
						}
						
									
					}%>							  
		  
				<%	for(int i = 0 ; i < 2 ; i++){%>
                <tr> 
                    <%if(i==0){%><td width="40" rowspan="3" align="center">렌트</td><%}%>
                    <td width="110" align="center"><%=bus_st2_nm[i]%></td>					
					<%	for (int j = (f_year-f_year_m  ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){%>	
                    <td align="right">
						<%if(i==0){%>		<%=Util.parseDecimal(cnt1[j])%>
						<%}else if(i==1){%>	<%=Util.parseDecimal(cnt2[j])%>				
						<%}%>
					</td>
		  <td align="right">
						<%if(i==0){%>		<%=AddUtil.parseFloatCipher2(acnt1[j]/cnt1[j],1)%>
						<%}else if(i==1){%>	<%=AddUtil.parseFloatCipher2(acnt2[j]/cnt2[j],1)%>				
						<%}%>
					</td>
					
					<%	}%>
                </tr>	
                <%	}%>	  
		<tr>
					<td class=title>소계 평균</td>
					<%	for (int j = (f_year-f_year_m  ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){%>	
                    <td class=title style='text-align:right'><%=Util.parseDecimal(h_cnt[j])%><br><%=Util.parseDecimal(ah_cnt[j])%></td>
                        <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher2(ah_cnt[j]/h_cnt[j],1)%></td>
                          
					<%	}%>					
				</tr>				
  
         		<tr>
					<td colspan='2' class=title>총계 평균</td>
					<%	for (int j = (f_year-f_year_m ) ; j <= (AddUtil.getDate2(1)-f_year_m) ; j++){%>	
                    <td class=title style='text-align:right'><%=Util.parseDecimal(t_cnt[j])%><br><%=Util.parseDecimal(at_cnt[j])%></td>
                     <td class=title style='text-align:right'><%=AddUtil.parseFloatCipher2(at_cnt[j]/t_cnt[j],1)%></td>
                
					<%	}%>					
				</tr>		
											
        </table>
	  </td>
	</tr>
</table>		
</form>
<script language='javascript'>
<!--
//-->
</script>

</body>
</html>


