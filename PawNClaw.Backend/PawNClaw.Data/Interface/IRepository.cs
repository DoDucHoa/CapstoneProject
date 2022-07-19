using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Data.Interface
{
    public interface IRepository<T> where T : class
    {
        //Get theo Id
        T Get(string id);

        T Get(int id);
        //Get theo dạng list có sort, filter và includeProperties
        IEnumerable<T> GetAll(
            Expression<Func<T, bool>> filter = null,
            Func<IQueryable<T>, IOrderedQueryable<T>> orderBy = null,
            string includeProperties = null
            );

        //Get thằng đầu tiên thấy có filter, incldueProperties
        T GetFirstOrDefault(
            Expression<Func<T, bool>> filter = null,
            string includeProperties = null
            );
        void Add(T entity);
        //Remove theo Id
        void Remove(String id);
        void Remove(int id);
        //Update theo entity
        void Update(T entity);
        //Remove theo entity
        void Remove(T entity);
        //Remove một chuỗi entity
        void RemoveRange(IEnumerable<T> entity);
        bool SaveDbChange();
        public Task<bool> SaveDbChangeAsync();
    }
}
