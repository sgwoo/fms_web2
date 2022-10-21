<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.arrear.ArrearDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun"); //영업소 (지점)
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	
	
		
	Vector buss1 = ad_db.getFeeScdSum("0001", "", "3", "3", "2");
	int bus_size1 = buss1.size();
	
	Vector buss2 = ad_db.getFeeScdSum("0002", "", "3", "3", "2");
	int bus_size2 = buss2.size();
		
	Vector buss3 = ad_db.getFeeScdSum("9999", "", "3", "3", "2");
	int bus_size3 = buss3.size();
	
	Vector buss4 = ad_db.getFeeScdSum("0007", "", "3", "3", "2");
	int bus_size4 = buss4.size();
					
	Vector buss5 = ad_db.getFeeScdSum("0008", "", "3", "3", "2");
	int bus_size5 = buss5.size();
				
	
	int d_cnt[] 	= new int[6];
	int d_amt[] 	= new int[6];
	int h_cnt[] 	= new int[6];
	int h_amt[] 	= new int[6];
	int t_cnt[] 	= new int[6];
	int t_amt[] 	= new int[6];
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
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

	function stat_search(mode, bus_id2){	
		var fm = document.form1;	
		parent.location.href = "/acar/arrear/arrear_frame_s.jsp?gubun1=1&gubun2=3&gubun3=3&gubun4=2&s_kd=8&t_wd="+bus_id2;		
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form action="stat_bus_sc_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='bus_size1' value='<%=bus_size1%>'>
<input type='hidden' name='bus_size2' value='<%=bus_size2%>'>
<input type='hidden' name='bus_size3' value='<%=bus_size3%>'>
<input type='hidden' name='bus_size4' value='<%=bus_size4%>'>
<input type='hidden' name='bus_size5' value='<%=bus_size5%>'>
<input type='hidden' name='s_user' value=''>
<input type='hidden' name='s_dept' value=''>
<input type='hidden' name='s_mng_way' value=''>
<input type='hidden' name='s_mng_st' value=''>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='bus_id2' value=''>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class=line width='30%' id='td_title' style='position:relative;'> 
	        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width="40%" style='height:45'>부서</td>
                    <td class=title width="30%">성명</td>
                    <td class=title width="30%">입사일자</td>
                </tr>
            </table>
        </td>
	    <td width='70%' class=line>
	        <table width='100%' border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title colspan="2">합계</td>
                    <td class=title colspan="2">대여료</td>
                    <td class=title colspan="2">정산금</td>     
                </tr>
                <tr> 
                    <td class=title width="16%" >건수</td>
                    <td class=title width="17%" >금액</td>
                    <td class=title width="16%" >건수</td>
                    <td class=title width="17%" >금액</td>
                    <td class=title width="16%" >건수</td>
                    <td class=title width="18%" >금액</td>                
                </tr>
            </table>
	    </td>
    </tr>  			  
    <tr>
	    <td class='line' width='30%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for (int i = 0 ; i < bus_size1 ; i++){
				Hashtable ht = (Hashtable)buss1.elementAt(i);%>
                <tr> 
            <%	if(i==0){%>
                    <td align="center" width="40%"  rowspan="<%=bus_size1%>">영업팀</td>
                    <%	}else{}%>
                    <td align="center" width="30%"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
                    <td align="center" width="30%"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            
                </tr>
          <%		
		  	}%>
		 <%  if  (bus_size1 > 0 ) { %>  	
                <tr> 
                    <td class="title" align="center" colspan="3">&nbsp;소계</td>
                </tr>
      	 <%		
		  	}%>
		  	
          <%for (int i = 0 ; i < bus_size2 ; i++){
				Hashtable ht = (Hashtable)buss2.elementAt(i);%>
                <tr> 
            <%	if(i==0){%>
                    <td align="center" rowspan="<%=bus_size2%>">고객지원팀</td>
            <%	}else{}%>
                    <td align="center"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            
                </tr>
          <%		
		  	}%>
		  <%  if  (bus_size2 > 0 ) { %>  		
                <tr> 
                    <td class="title" align="center" colspan="3" height="20">&nbsp;소계</td>
                </tr>
           <%		
		  	}%>
            <%for (int i = 0 ; i < bus_size3 ; i++){
				Hashtable ht = (Hashtable)buss3.elementAt(i);%>
                <tr> 
            <%	if(i==0){%>
                    <td align="center" rowspan="<%=bus_size3%>" height="20">기타 </td>
            <%	}else{}%>
        
                    <td align="center"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
            
                </tr>
          <%		
		  	}%>
		  <%  if  (bus_size3 > 0 ) { %>  		
                <tr> 
                    <td class="title" align="center" colspan="3">&nbsp;소계</td>
                </tr>
           <%		
		  	}%>
          <%for (int i = 0 ; i < bus_size4 ; i++){
				Hashtable ht = (Hashtable)buss4.elementAt(i);%>
                <tr> 
            <%	if(i==0){%>
                    <td align="center" rowspan="<%=bus_size4%>">부산지점</td>
            <%	}else{}%>
                    <td align="center"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
         
                </tr>
          <%		
		  	}%>
		  <%  if  (bus_size4 > 0 ) { %>  		
                <tr> 
                    <td class="title" align="center" colspan="3">&nbsp;소계</td>
                </tr>
           <%		
		  	}%>
          <%for (int i = 0 ; i < bus_size5 ; i++){
				Hashtable ht = (Hashtable)buss5.elementAt(i);%>
                <tr> 
            <%	if(i==0){%>
                    <td align="center" rowspan="<%=bus_size5%>" height="20">대전지점</td>
            <%	}else{}%>
                    <td align="center"><a href="javascript:stat_search('d','<%=ht.get("BUS_ID2")%>');" onMouseOver="window.status=''; return true"><font color="#0000FF"><%=ht.get("BUS_NM2")%></font></a></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> </td>
       
                </tr>
          <%		
		  	}%>
		  <%  if  (bus_size5 > 0 ) { %>  		
                <tr> 
                    <td class="title" align="center" colspan="3">&nbsp;소계</td>
                </tr>
           <%		
		  	}%>
		  	
                <tr> 
                    <td class="title_p" align="center" colspan="3">&nbsp;총합계</td>
           
                </tr>
            </table>
        </td>
        
        
	    <td class='line' width='70%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for (int i = 0 ; i < bus_size1 ; i++){
				Hashtable ht = (Hashtable)buss1.elementAt(i);
				
				d_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[0] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				
				%>
                <tr> 
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="18%"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>원&nbsp;</td>																																				
                </tr>
          <%		
			}%>
		  <%  if  (bus_size1 > 0 ) { %>  		
                <tr> 
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(t_cnt[0])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(t_amt[0])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(d_cnt[0])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(d_amt[0])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(h_cnt[0])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="18%"><%=Util.parseDecimal(h_amt[0])%>원&nbsp;</td>																																				
                </tr>
           <%		
			}%>
          <%for (int i = 0 ; i < bus_size2 ; i++){
          		Hashtable ht = (Hashtable)buss2.elementAt(i);
				
				d_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[1] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				
				%>
                <tr> 
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="18%"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>원&nbsp;</td>																																				
                </tr>
          <%		
			}%>
		 <%  if  (bus_size2 > 0 ) { %>  			
                <tr> 
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(t_cnt[1])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(t_amt[1])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(d_cnt[1])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(d_amt[1])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(h_cnt[1])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="18%"><%=Util.parseDecimal(h_amt[1])%>원&nbsp;</td>																																				
                </tr>
             <%		
			}%>
           <%for (int i = 0 ; i < bus_size3 ; i++){
          		Hashtable ht = (Hashtable)buss3.elementAt(i);
				
				d_cnt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[2] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				
				%>
                <tr> 
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="18%"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>원&nbsp;</td>																																				
                </tr>
          <%		
			}%>
		 <%  if  (bus_size3 > 0 ) { %>  			
                <tr> 
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(t_cnt[2])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(t_amt[2])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(d_cnt[2])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(d_amt[2])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(h_cnt[2])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="18%"><%=Util.parseDecimal(h_amt[2])%>원&nbsp;</td>																																				
                </tr>
             <%		
			}%>
     
          <%for (int i = 0 ; i < bus_size4 ; i++){
				Hashtable ht = (Hashtable)buss4.elementAt(i);
				
				d_cnt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[3] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
			%>
                <tr> 
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="18%"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>원&nbsp;</td>																																					
                </tr>
          <%		
			}%>
		 <%  if  (bus_size4 > 0 ) { %>  			
                <tr> 
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(t_cnt[3])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(t_amt[3])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(d_cnt[3])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(d_amt[3])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(h_cnt[3])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="18%"><%=Util.parseDecimal(h_amt[3])%>원&nbsp;</td>																																				
                </tr>
           <%		
			}%>
          <%for (int i = 0 ; i < bus_size5 ; i++){
				Hashtable ht = (Hashtable)buss5.elementAt(i);
				
				d_cnt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT")));
				d_amt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT")));
				h_cnt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				h_amt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
				t_cnt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")));
				t_amt[4] 	+= AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")));
		  %>
                <tr> 
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_CNT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_CNT")))) %>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("TOT_D_AMT"))) + AddUtil.parseInt(String.valueOf(ht.get("TOT_H_AMT")))) %>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_D_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="17%"><%=Util.parseDecimal(ht.get("TOT_D_AMT"))%>원&nbsp;</td>
                    <td align="right" height="20" width="16%"><%=Util.parseDecimal(ht.get("TOT_H_CNT"))%>건&nbsp;</td>
                    <td align="right" height="20" width="18%"><%=Util.parseDecimal(ht.get("TOT_H_AMT"))%>원&nbsp;</td>																																					
                </tr>
          <%		
			}%>
		 <%  if  (bus_size5 > 0 ) { %>  			
                <tr> 
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(t_cnt[4])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(t_amt[4])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(d_cnt[4])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(d_amt[4])%>원&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(h_cnt[4])%>건&nbsp;</td>
                    <td class=title style='text-align:right' height="20" width="18%"><%=Util.parseDecimal(h_amt[4])%>원&nbsp;</td>																																				
                </tr>
            <%		
			}%> 
                <tr> 
                    <td class=title_p style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(t_cnt[0]+t_cnt[1]+t_cnt[2]+t_cnt[3]+t_cnt[4])%>건&nbsp;</td>
                    <td class=title_p style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(t_amt[0]+t_amt[1]+t_amt[2]+t_amt[3]+t_amt[4])%>원&nbsp;</td>
                    <td class=title_p style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(d_cnt[0]+d_cnt[1]+d_cnt[2]+d_cnt[3]+d_cnt[4])%>건&nbsp;</td>
                    <td class=title_p style='text-align:right' height="20" width="17%"><%=Util.parseDecimal(d_amt[0]+d_amt[1]+d_amt[2]+d_amt[3]+d_amt[4])%>원&nbsp;</td>
                    <td class=title_p style='text-align:right' height="20" width="16%"><%=Util.parseDecimal(h_cnt[0]+h_cnt[1]+h_cnt[2]+h_cnt[3]+h_cnt[4])%>건&nbsp;</td>
                    <td class=title_p style='text-align:right' height="20" width="18%"><%=Util.parseDecimal(h_amt[0]+h_amt[1]+h_amt[2]+h_amt[3]+h_amt[4])%>원&nbsp;</td>																																				
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
