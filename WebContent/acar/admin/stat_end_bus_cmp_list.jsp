<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_stat(save_dt){
	
		var fm = document.form1;	
		
		fm.save_dt.value = replaceString("-","",save_dt);
			
		//�򰡱Ⱓ������ ����������
		if(toInt(fm.save_dt.value) > 20190501){
			if(fm.loan_st[0].checked == true){ 				
				fm.action='/acar/stat_month/campaign2019_5_sc1.jsp';		
			}else if(fm.loan_st[1].checked == true){ 				
				fm.action='/acar/stat_month/campaign2019_5_sc2.jsp';		
			}	
		}else{
			alert('2019��05�������� 1������ 1������, 2������, 2���������� ������ �־� ����ʹ� �ٸ��ϴ�.');
			//�򰡱Ⱓ������ ����������
			if(toInt(fm.save_dt.value) > 20140501){
				if(fm.loan_st[0].checked == true){ 				
					fm.action='/acar/stat_month/campaign2014_5_sc1.jsp';		
				}else if(fm.loan_st[1].checked == true){ 				
					fm.action='/acar/stat_month/campaign2014_5_sc3.jsp';		
				}else if(fm.loan_st[2].checked == true){ 				
					fm.action='/acar/stat_month/campaign2014_5_sc4.jsp';		
				}else if(fm.loan_st[4].checked == true){ 				
					fm.action='/acar/stat_month/campaign2014_1_sc2.jsp';		
				}						
			}else{
				//�򰡱Ⱓ������ ����������
				if(toInt(fm.save_dt.value) > 20130123){
					if(fm.loan_st[0].checked == true){ 				
						fm.action='/acar/stat_month/campaign2013_1_sc2.jsp';		
					}else if(fm.loan_st[1].checked == true){ 				
						fm.action='/acar/stat_month/campaign2013_1_sc3.jsp';		
					}else{											
						fm.action='/acar/stat_month/campaign2013_1_sc4.jsp';		
					}						
				}else{
					if(toInt(fm.save_dt.value) > 20120509){					
						if(fm.loan_st[0].checked == true){ 				
							fm.action='/acar/stat_month/campaign2012_5_sc2.jsp';		
						}else if(fm.loan_st[1].checked == true){ 				
							fm.action='/acar/stat_month/campaign2012_5_sc3.jsp';		
						}else{											
							fm.action='/acar/stat_month/campaign2012_5_sc4.jsp';		
						}						
					}else{
						if(fm.loan_st[0].checked == true){ 				
							fm.action='/acar/stat_month/campaign2011_5_sc2.jsp';		
						}else{											
							fm.action='/acar/stat_month/campaign2011_5_sc3.jsp';		
						}		
					}
				}
			}		
		}
		
		fm.target='_blank';
		fm.submit();		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	
	//��ä��Ȳ
	Vector deb1s = ad_db.getStatDebtList("stat_bus_cmp");
	int deb1_size = deb1s.size();
%>
<form name='form1' action='stat_car_sc_in_view.jsp' target='i_view'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<table border="0" cellspacing="0" cellpadding="0" width="<%=(deb1_size*80)+300%>">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width='80' >��������</td>
					<td class="title" width='220' >
					  <input type='radio' name="loan_st" value='1' checked>
        				1��
        			  <input type='radio' name="loan_st" value='2'>
        				2��
        				(2019��5������)
        			 <!-- 											
					  <input type='radio' name="loan_st" value='1' checked>
        				1�� ����
        			  <input type='radio' name="loan_st" value='2_1'>
        				2�� ����
        				<input type='radio' name="loan_st" value='2_2'>
        				2�� ����
        				<input type='radio' name="loan_st" value='1_2'>
        				1�� ����
        				 -->
					</td>
                      <%if(deb1_size > 0){
            				for(int i = 0 ; i < deb1_size ; i++){
            					StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>			
                        <td width='80' align='center'><a href="javascript:view_stat('<%=sd.getSave_dt()%>');"><%=sd.getSave_dt()%></a></td>
                      <%	}
            			}else{%>
			        <td align='center'>����Ÿ�� �����ϴ�</td>						
                <%}%>
                </tr>		  
            </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
