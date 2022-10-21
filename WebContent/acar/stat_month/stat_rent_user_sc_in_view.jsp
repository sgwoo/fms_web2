<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*"%>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String s_yy = request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	s_yy = AddUtil.replace(s_yy,"-","");
	s_mm = AddUtil.replace(s_mm,"-","");
	
	Vector vt = sb_db.getStatRentUserDept("", "", s_yy, s_mm);
	int vt_size = vt.size();

	int count = 1;
	
	//작은그룹 소계
	int cnt1[] 	= new int[25];
	//큰그룹 소계
	int cnt2[] 	= new int[25];
	//총합계
	int cnt3[] 	= new int[25];
	
	//큰그룹
	String gubun_cd[] 	= new String[5];
	gubun_cd[0] 	= "12";
	gubun_cd[1] 	= "11";
	gubun_cd[2] 	= "22";
	gubun_cd[3] 	= "21";
	gubun_cd[4] 	= "33";
	//큰그룹
	String gubun_nm[] 	= new String[5];
	gubun_nm[0] 	= "수도권 영업팀";
	gubun_nm[1] 	= "수도권 고객지원팀";
	gubun_nm[2] 	= "지점 영업팀";
	gubun_nm[3] 	= "지점 고객지원팀";
	gubun_nm[4] 	= "에이전트";	
	
	//작은그룹 : 지점-군 구분
	Vector vt2 = sb_db.getStatRentDept();
	int vt_size2 = vt2.size();	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1480>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr>
	    <td class=line> 
	        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td class=title rowspan="2" width="110" >부서</td>
                    <td class=title rowspan="2" width="30">연번</td>
                    <td class=title rowspan="2" width="50">성명</td>
                    <td class=title rowspan="2" width="90">입사일자</td>               
                    <td class=title rowspan="2" width="50"> 총합계</td>
                    <td class=title colspan="7">합계</td>
                    <td class=title colspan="7">일반식</td>
                    <td class=title colspan="7">기본식</td>
                    <td class=title rowspan="2" width="50">전자<br>계약</td>
                    <td class=title rowspan="2" width="50">월렌트</td>
                </tr>
                <tr align="center"> 
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">소계</td>
                    <td class=title width="50">재리스</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">계</td>
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">소계</td>
                    <td class=title width="50">재리스</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">계</td>
                    <td class=title width="50">신규</td>
                    <td class=title width="50">대차</td>
                    <td class=title width="50">증차</td>
                    <td class=title width="50">소계</td>
                    <td class=title width="50">재리스</td>
                    <td class=title width="50">연장</td>
                    <td class=title width="50">계</td>                                                            
                </tr>
                <%for (int g = 0 ; g < 5 ; g++){
                		for (int k = 0 ; k < 24 ; k++){ cnt2[k] = 0; }		               	
           	    %> 	            
           	    
           	    
           	    
                <%		for (int i = 0 ; i < vt_size2 ; i++){
    						Hashtable ht2 = (Hashtable)vt2.elementAt(i);	
   							if(gubun_cd[g].equals(String.valueOf(ht2.get("LOC_ST"))+""+String.valueOf(ht2.get("LOAN_ST")))){
   								for (int k = 0 ; k < 24 ; k++){ cnt1[k] = 0; }	
           	    				for (int j = 0 ; j < vt_size ; j++){
    								Hashtable ht = (Hashtable)vt.elementAt(j);    					
    								if(String.valueOf(ht.get("BR_NM")).equals(String.valueOf(ht2.get("BR_NM")))){    						
           	    %>


               <tr> 
                    <td align="center" width="110" height="20"><%= String.valueOf(ht.get("BR_NM"))%></td>
                    <td align="center" width="30" height="20"><%=count++%></td>
                    <td align="center" width="50" height="20"><%= String.valueOf(ht.get("USER_NM"))%></font></a></td>
                    <td align="center" width="90" height="20"><%=AddUtil.ChangeDate2( String.valueOf(ht.get("ENTER_DT")))%></td>
                    <%					for (int k = 0 ; k < 24 ; k++){
                    						cnt1[k] = cnt1[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    						cnt2[k] = cnt2[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    						cnt3[k] = cnt3[k] + AddUtil.parseInt(String.valueOf(ht.get("CNT"+k)));
                    %>
	                <td align="center" <%if(k==7 || k==14 || k==21){%>class=g<%}%>><%= String.valueOf(ht.get("CNT"+k))%></td>
	                <%					}%>
                </tr>
                <%					}
	            				}	                		
                %> 
                

                <tr> 
                    <td class=is align="center" colspan='4'><%= String.valueOf(ht2.get("BR_NM"))%> 소계</td>
                    <%			for (int k = 0 ; k < 24 ; k++){%>
	                <td class=is align="center"><%=cnt1[k]%></td>
	                <%			}%>
                </tr>                	
                <%			}%>

                <%		}%>           	    
           	    
           	    
           	    
           	    
           	    
           	    <%			if(!gubun_nm[g].equals("에이전트")){ %>		

                <tr> 
                    <td class=title colspan='4'><%=gubun_nm[g]%> 소계</td>
                    <%		for (int k = 0 ; k < 24 ; k++){%>
	                <td class=title><%=cnt2[k]%></td>
	                <%		}%>
                </tr>           
                
                <%			} %>            
                
                
                
                <%	}%>
                
                <tr> 
                    <td class=title_p colspan='4'>총소계</td>
                    <%		for (int k = 0 ; k < 24 ; k++){%>
	                <td class=title_p><%=cnt3[k]%></td>
	                <%		}%>
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
