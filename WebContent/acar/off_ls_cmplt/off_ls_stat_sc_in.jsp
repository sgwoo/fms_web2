<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_cmplt.*"%>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")		==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")		==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")		==null?"":request.getParameter("gubun3");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au 		= request.getParameter("s_au")==null?"":request.getParameter("s_au");
	
	
	Vector vt = olcD.getCmplt_stat_lst(dt, ref_dt1, ref_dt2, gubun, gubun1, gubun2, gubun3, gubun_nm, br_id, s_au);
	int vt_size = vt.size();	
			
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;	
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;

	long out_amt = 0;
	long comm2_tot	=0;
	
	//평균재리스잔존가대비율 구하기
	float use_per1 = 0;
	float use_per2 = 0;
	float use_per3 = 0;
	float use_per4 = 0;
	
	float use_cnt1 = 0;
	float use_cnt2 = 0;
	float use_cnt3 = 0;
	float use_cnt4 = 0;
	
	float avg_per1 = 0;
	float avg_per2 = 0;
	float avg_per3 = 0;
	float avg_per4 = 0;
	float avg_per5 = 0;
	float avg_per6 = 0;
	float avg_per7 = 0;
	float avg_per8 = 0;
	float avg_per9 = 0;




%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
<form name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'> 
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun_nm' value='<%=gubun_nm%>'>
<input type='hidden' name='dt' value='<%=dt%>'>
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'>
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>
<input type='hidden' name='s_au' value='<%=s_au%>'>
<table border=0 cellspacing=0 cellpadding=0 width="3180">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td colspan=2 class=line2></td>
                </tr>
	        <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td class='line' id='td_title' style='position:relative;' width='530'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>                                 
                                <td width='30'  class='title' style='height:67'>연번</td>
                                <td width='75'  class='title'>차량번호</td>				  
                                <td width='185' class='title'>차명</td>
                                <td width='100' class='title'>경매장</td>				  								
				<td width='70'  class='title'>경매일자</td>
                                <td width='70'  class='title'>최초등록일</td>				  
                            </tr>
                        </table>
                    </td>		
                    <td class='line' width='2650'>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='100' class='title' rowspan="2">소비자가격</td>
                                <td width='100' class='title' rowspan="2">구입가격</td>
                                <td width='100' class='title' rowspan="2">희망가</td>
                                <td width='100'class='title' rowspan="2">예상낙찰가</td>
                                <td colspan="7" class='title'>매각(낙찰)</td>
                                <td width='50' class='title' rowspan="2">차령</td>                                
				<td width='70' class='title' rowspan="2">주행<br>거리</td>
				<td width='60' class='title' rowspan="2">경매장<br>평점</td>
				<td width='90' class='title' rowspan="2">마지막위치</td>
                                <td width='40' class='title' rowspan="2">사고<br>유무</td>
				<td colspan="2" class='title'>사고수리비</td>
				<td colspan="5" class='title'>매각 수수료</td>
                                <td width='100' class='title' rowspan="2">낙찰자</td>
                                <td width='200' class='title' rowspan="2">선택사양</td>
                                <td width='90' class='title' rowspan="2">선택사양가</td>
                                <td width='60' class='title' rowspan="2">배기량</td>
                                <td width='100' class='title' rowspan="2">연료</td>
                                <td width='100' class='title' rowspan="2">색상</td>
                                <td width='100' class='title' rowspan="2">내장색상</td>
                                <td width='50' class='title' rowspan="2">차종<br>코드</td>
                            </tr>
                            <tr> 								
                                <td width='100' class='title'>낙찰가</td>
                                <td width='70' class='title'>소비자가<br>대비</td>
                                <td width='70'  class='title'>구입가<br>대비</td>				  
                                <td width='80' class='title'>예상낙찰가<br>대비</td>		
                                <td width='100' class='title'>편차금액</td>		
                                <td width='80' class='title'>편차%<br>(예상낙찰가<br>기준)</td>		
                                <td width='70' class='title'>편차%<br>(소비자가<br>기준)</td>		
				<td width='100' class='title'>수리금액</td>
				<td width='100' class='title'>소비자가<br>대비</td>								
                                <td width='100' class='title'>낙찰<br>수수료</td>
                                <td width='70' class='title'>출품<br>수수료</td>
				<td width='70' class='title'>재출품<br>수수료</td>
                                <td width='70' class='title'>반입<br>탁송대금</td>
				<td width='70' class='title'>합계</td>
                            </tr>
                        </table>
                    </td>
	        </tr>
		<%if(vt_size > 0 ){%>
	        <tr>
                    <td class='line' id='td_con' style='position:relative;' width='530'> 
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
			    <% 	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
			    <tr> 
                                <td width='30'  align='center'><%=i+1%></td>
                                <td width='75'  align='center'><a href="javascript:parent.view_detail('<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("SEQ")%>')">                                
                                				<%if(String.valueOf(ht.get("A_CNT")).equals("0")){//수해경력없음%>
								<%=ht.get("CAR_NO")%>
								<%	}else{//수해차량%>			  
								<font color="#ff8200"><%=ht.get("CAR_NO")%></font> 						
								<%	}%>                                
                                </a></td>
                                <td width='185' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("CAR_NM")), 26)%></span></td>
				<td width='100' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("FIRM_NM")), 10)%><%=ht.get("ACTN_WH")%></span></td>
				<td width='70'  align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACTN_DT")))%></td>
                                <td width='70'  align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>				  
                            </tr>
                            <%	}%>
                            <tr> 
                                <td class='title' rowspan='3' colspan='3'>편차 절대값 반영</td>
                                <td class='title' colspan='3'>합계</td>
                            </tr>
                            <tr> 
                                <td class='title' colspan='3'>평균(평균금액 대 평균금액으로 계산)</td>
                            </tr>                            
                            <tr> 
                                <td class='title' colspan='3'>평균(대비율의 평균)</td>
                            </tr>         
                            <tr> 
                                <td class='title' rowspan='3' colspan='3'>편차 부호 반영</td>
                                <td class='title' colspan='3'>합계</td>
                            </tr>
                            <tr> 
                                <td class='title' colspan='3'>평균(평균금액 대 평균금액으로 계산)</td>
                            </tr>                            
                            <tr> 
                                <td class='title' colspan='3'>평균(대비율의 평균)</td>
                            </tr>                                                      
                        </table>
                    </td>
                    <td class='line' width='2650'>
                        <table border="0" cellspacing="1" cellpadding="0" width=100% >
			    <% 	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
							
					total_amt1 	= total_amt1  + AddUtil.parseLong(String.valueOf(ht.get("CAR_C_AMT")));
					total_amt2 	= total_amt2  + AddUtil.parseLong(String.valueOf(ht.get("CAR_F_AMT")));
					total_amt3 	= total_amt3  + AddUtil.parseLong(String.valueOf(ht.get("CAR_S_AMT")));
					total_amt4 	= total_amt4  + AddUtil.parseLong(String.valueOf(ht.get("HP_PR")));
					total_amt5 	= total_amt5  + AddUtil.parseLong(String.valueOf(ht.get("NAK_PR")));								
					total_amt6 	= total_amt6  + AddUtil.parseLong(String.valueOf(ht.get("COMM1_TOT")));					
					total_amt8 	= total_amt8  + AddUtil.parseLong(String.valueOf(ht.get("COMM3_TOT")));
					total_amt9 	= total_amt9  + AddUtil.parseLong(String.valueOf(ht.get("COMM_TOT")));
					total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("HAP_AMT")));								
					total_amt12 	= total_amt12 + AddUtil.parseLong(String.valueOf(ht.get("ABS_HP_S_CHA_AMT")));
					total_amt13 	= total_amt13 + AddUtil.parseLong(String.valueOf(ht.get("HP_S_CHA_AMT")));
					total_amt15	= total_amt15 + AddUtil.parseLong(String.valueOf(ht.get("KM")));
					total_amt16	= total_amt16 + AddUtil.parseLong(String.valueOf(ht.get("OPT_AMT")));
								
							
					if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 60500){
						comm2_tot 	= AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
						total_amt7	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
					}else{
						out_amt = AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
						total_amt10	= total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
					}
								
					float use_per = AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_PER")),2));
								
					if(String.valueOf(ht.get("CLIENT_ID")).equals("000502")){//시화-현대글로비스(주)
						use_cnt1++;
						use_per1 = use_per1 + use_per;
					}else if(String.valueOf(ht.get("CLIENT_ID")).equals("013011")){//분당-현대글로비스(주)
						use_cnt2++;
						use_per2 = use_per2 + use_per;
					}else if(String.valueOf(ht.get("CLIENT_ID")).equals("022846")){//동화엠파크 013222-> 20150515 (주)케이티렌탈 022846
						use_cnt3++;
						use_per3 = use_per3 + use_per;
					}else if(String.valueOf(ht.get("CLIENT_ID")).equals("011723")||String.valueOf(ht.get("CLIENT_ID")).equals("020385")){//(주)서울자동차경매 -> 에이제이셀카 주식회사
						use_cnt4++;
						use_per4 = use_per4 + use_per;
					}	
					
					avg_per1 = avg_per1 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_PER")),2));
					avg_per2 = avg_per2 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_F_PER")),2));
					avg_per3 = avg_per3 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_PER")),2));
					avg_per4 = avg_per4 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("ABS_HP_S_CHA_PER")),2));
					avg_per5 = avg_per5 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("ABS_HP_C_CHA_PER")),2));
					avg_per6 = avg_per6 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_CHA_PER")),2));
					avg_per7 = avg_per7 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_CHA_PER")),2));
					avg_per8 = avg_per8 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("SE_PER")),2));
					avg_per9 = avg_per9 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("CAR_OLD_MONS")),1));
								
							
			    %>
                            <tr>
				<td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>
				<td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
				<td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("HP_PR")))%></td>
				<td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_S_AMT")))%></td>
				<td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("NAK_PR")))%></td>
				<td width='70' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_PER")),2)%>%</td>
				<td width='70' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_F_PER")),2)%>%</td>							  
				<td width='80' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_PER")),2)%>%</td>
				<td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("HP_S_CHA_AMT")))%></td>
				<td width='70' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_CHA_PER")),2)%>%</td>
				<td width='70' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_CHA_PER")),2)%>%</td>
				<td width='50' align='center'><%=ht.get("CAR_OLD_MONS")%></td>
				<td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("KM")))%></td>
				<td width='60' align='center'><%=ht.get("ACTN_JUM")%></td>
				<td width='90' align='center'><%=ht.get("PARK_NM")%></td>
				<td width='40' align='center'><%=ht.get("ACCID_YN")%></td>
				<td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("HAP_AMT")))%></td>
				<td width='100' align='right'><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("SE_PER")),2)%>%</td>								
				<td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("COMM1_TOT")))%></td>
				<td width='70' align='right'><%=AddUtil.parseDecimal(comm2_tot)%></td>
				<td width='70' align='right'><%=AddUtil.parseDecimal(out_amt)%></td>
				<td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("COMM3_TOT")))%></td>							  
				<td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("COMM_TOT")))%></td>							  
				<td width='100' align='center'><span title='<%=ht.get("SUI_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("SUI_NM")), 6)%></span></td>							
				<td width='200' align='center'><span title='<%=ht.get("OPT")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("OPT")), 28)%></td>
				<td width='90' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OPT_AMT")))%></td>
				<td width='60' align='center'><%=ht.get("DPM")%></td>
				<td width='100' align='center'><%=ht.get("FUEL_KD")%></td>
				<td width='100' align='center'><span title='<%=ht.get("COLO")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("COLO")), 12)%></td>
				<td width='100' align='center'><span title='<%=ht.get("IN_COL")%>'><%=AddUtil.substringbdot(String.valueOf(ht.get("IN_COL")), 12)%></td>
				<td width='50' align='center'><%=ht.get("JG_CODE")%></td>
                            </tr>				
                            <% 		out_amt 	= 0;
					comm2_tot 	= 0;
				}
			    %>
			    <tr> 
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt4)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt5)%></td>            		        
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt12)%></td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt11)%></td>            		        
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt6)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt7)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt10)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt8)%></td>            		        
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt9)%></td>            		                    		        
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt16)%></td>            		                    		        
                                <td class='title' colspan='5'>&nbsp;</td>
			    </tr>
			    <tr> 
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt1/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt2/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt4/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt3/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt5/vt_size)))%></td>            		        
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt2))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt5))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt12/vt_size)))%></td>								
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt12))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt12))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2)%>%</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt11/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt11))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt6/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt7/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt10/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt8/vt_size)))%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt9/vt_size)))%></td>
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt16/vt_size)))%></td>
                                <td class='title' colspan='5'>&nbsp;</td>
			    </tr>		
			    <tr> 
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per1/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per2/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per3/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'></td>								
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per4/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per5/vt_size,2)%>%</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per8/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'></td>
                                <td class='title' colspan='5'>&nbsp;</td>
			    </tr>	
			    <tr> 
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt13)%></td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'>&nbsp;</td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'>-</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'></td>            		                    		        
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'></td>
                                <td class='title' colspan='5'>&nbsp;</td>
			    </tr>
			    <tr> 
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt13/vt_size)))%></td>								
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt13))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt3))/vt_size)*100,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher((AddUtil.parseFloat(String.valueOf(total_amt13))/vt_size)/(AddUtil.parseFloat(String.valueOf(total_amt1))/vt_size)*100,2)%>%</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'></td>            		        
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'></td>
                                <td class='title' colspan='5'>&nbsp;</td>
			    </tr>		
			    <tr> 
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>            		        
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>								
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per6/vt_size,2)%>%</td>
				<td class='title' style='text-align:right'><%=AddUtil.parseFloatCipher(avg_per7/vt_size,2)%>%</td>
				<td class='title'><%=AddUtil.parseFloatCipher(avg_per9/vt_size,1)%></td>
				<td class='title' style='text-align:right'><%=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf(total_amt15/vt_size)))%></td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' colspan=''>&nbsp;</td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
				<td class='title' style='text-align:right'></td>
                                <td class='title' colspan='2'>&nbsp;</td>
                                <td class='title' style='text-align:right'></td>
                                <td class='title' colspan='5'>&nbsp;</td>
			    </tr>				    				    					
                        </table>
                    </td>
	        </tr>
		<%}else{%>
	        <tr>
	            <td class='line' id='td_con' style='position:relative;' width='530'> 
	                <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td align='center'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
	            <td class='line' width='2650'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 차량이 없읍니다.</td>
                            </tr>          
                        </table>
		    </td>
	        </tr>
		<%}%>		
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--
	parent.document.form1.avg_per1.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per1/use_cnt1), 2)%>';
	parent.document.form1.avg_per2.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per2/use_cnt2), 2)%>';
	parent.document.form1.avg_per3.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per3/use_cnt3), 2)%>';
	parent.document.form1.avg_per4.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per4/use_cnt4), 2)%>';
//-->
</script>

</body>
</html>