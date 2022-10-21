<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.insur.*"%>
<%@ page import="java.util.*,java.text.SimpleDateFormat"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>

</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border="1" cellspacing="0" cellpadding="0" width=700>
	<tr>
		<td width='50' align='center' style="font-size : 8pt;">����</td>
		<td width='100' align='center' style="font-size : 8pt;">����ȣ</td>
		<td width='250' align='center' style="font-size : 8pt;">ó�����</td>
		<td width='100' align='center' style="font-size : 8pt;">����ڵ�</td>
		<td width='50' align='center' style="font-size : 8pt;">������</td>
		<td width='50' align='center' style="font-size : 8pt;">���</td>
	</tr>  	

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String vid[] = request.getParameterValues("ch_l_cd");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	
	InsEtcDatabase ie_db = InsEtcDatabase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();

	int count=1;
	String  result ="";
	String car_mng_id = "";	
	boolean flag = false;	
	
	for(int i=0; i < vid.length; i++){
		String gubunVid[] = vid[i].split("/");
		
		car_mng_id 		= gubunVid[1];
		
		Hashtable ht = ie_db.getInsTaskNotStat(car_mng_id);
		
		InsurExcelBean ins = new InsurExcelBean();
		
		String curTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		String reg_code  = "BASE"+Long.toString(System.currentTimeMillis());
		
		String rent_mng_id  = String.valueOf(ht.get("RENT_MNG_ID"));
		String rent_l_cd = String.valueOf(ht.get("RENT_L_CD"));
		String ins_st = String.valueOf(ht.get("INS_ST"));
		String ins_com_emp_yn =  String.valueOf(ht.get("INS_COM_EMP_YN"));
		String cont_com_emp_yn = String.valueOf(ht.get("CONT_COM_EMP_YN"));
		//String car_mng_id = String.valueOf(ht.get("CAR_MNG_ID"));
		
		
		ins.setReg_code		(reg_code);
		ins.setSeq			(count);
		ins.setReg_id		(ck_acar_id);//��Ű���� ������ user_id��
		ins.setValue01		("��������̰���");
		ins.setValue02		(rent_mng_id);	
		ins.setValue03		(rent_l_cd);
		ins.setValue04		(ins_st);
		ins.setValue05		(curTime);
		ins.setValue06		("��������������");
		
		ins.setValue07		(ins_com_emp_yn);
		ins.setValue08		(cont_com_emp_yn);
		
		ins.setValue09		(rent_mng_id);
		ins.setValue10		(rent_l_cd);
		ins.setValue11		(car_mng_id);
		ins.setValue12		(ins_st);
		
		ins.setValue14		(cont_com_emp_yn);
		
		int cnt = ai_db.getCheckInsExcelInsTask(ins);
		if(cnt > 0){
			result = "�̹� �ѱ� ������ �Դϴ�.";
		}else{
			
			if(ins_com_emp_yn.equals(cont_com_emp_yn)){
				result = "�������� ������ ���Կ��ΰ� ���� �̰��� �Դϴ�.";
			}else{
				if(!ai_db.insertInsExcel2(ins)){
					result="ins_excel ��Ͻ� ������ �߻��Ͽ����ϴ�.";
				}else{
					flag =  ic_db.call_sp_ins_cng_req_com(reg_code,count);
				
					if(!flag){
						result = "ins_excel_com ��Ͻ� ������ �߻��߽��ϴ�.";
					}else{
						result = "���������� ó���Ǿ����ϴ�.";
					}
				}	
			}
		}
		
		
		%>	
	<tr>
		<td align='center' style="font-size : 8pt;"><%=count%></td>
	    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NO")%>(<%=car_mng_id%>)</td>
	    <td align='center' style="font-size : 8pt;"><%if(!flag){%><font color=red><%=result%></font><%}else{%><%=result%><%}%></td>
	    <td align='center' style="font-size : 8pt;"><%=reg_code%></td>
	    <td align='center' style="font-size : 8pt;"><%=count%></td>
	    <td align='center' style="font-size : 8pt;"><%=flag%></td>
	</tr>
		
<%		
		count+=1;
	}
	
	
%>
	</table>
	</form>
</body>
</html>
